import os
import json
import logging
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import requests

# Parameters
NIFI_BASE_URL = os.environ.get("NIFI_BASE_URL", "https://host.docker.internal:8443/nifi-api")
NIFI_USER = os.environ["NIFI_USERNAME"]
NIFI_PASS = os.environ["NIFI_PASSWORD"]
DBT_DIR = "/opt/airflow/dwh_project/dbt_agriculture"

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2026, 4, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(seconds=30),
}

def get_nifi_token():
    """Retrieves a JWT token from NiFi."""
    url = f"{NIFI_BASE_URL}/access/token"
    # For NiFi 2.x single user, often works best with form data
    payload = {'username': NIFI_USER, 'password': NIFI_PASS}
    response = requests.post(url, data=payload, verify=False)
    if response.status_code != 200:
        logging.error(f"Token failed: {response.status_code} - {response.text}")
    response.raise_for_status()
    return response.text

def get_processor_id(token, processor_name):
    """Finds a NiFi processor ID by its name."""
    url = f"{NIFI_BASE_URL}/flow/process-groups/root"
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(url, headers=headers, verify=False)
    response.raise_for_status()
    
    group_flow = response.json().get('processGroupFlow', {})
    processors = group_flow.get('flow', {}).get('processors', [])
    
    for proc in processors:
        if proc['status']['name'] == processor_name:
            return proc['id'], proc['revision']['version']
    
    raise Exception(f"Processor '{processor_name}' not found in NiFi.")

def change_processor_status(processor_name, state):
    """Starts or Stops a NiFi processor."""
    token = get_nifi_token()
    proc_id, version = get_processor_id(token, processor_name)
    url = f"{NIFI_BASE_URL}/processors/{proc_id}"
    headers = {"Authorization": f"Bearer {token}"}
    
    payload = {
        "revision": {"version": version},
        "component": {
            "id": proc_id,
            "state": state  # RUNNING or STOPPED
        }
    }
    
    response = requests.put(url, headers=headers, json=payload, verify=False)
    response.raise_for_status()
    logging.info(f"Processor {processor_name} set to {state}")

with DAG(
    'agriculture_dwh_pipeline',
    default_args=default_args,
    description='End-to-end monitoring and transformation pipeline',
    schedule_interval=timedelta(days=1),
    catchup=False
) as dag:

    # 1. Start NiFi Ingestion
    start_nifi = PythonOperator(
        task_id='start_nifi_ingestion',
        python_callable=change_processor_status,
        op_kwargs={'processor_name': 'GetFile', 'state': 'RUNNING'}
    )

    # 2. Run dbt Transformation
    # We use a bash command to run dbt inside the project folder
    run_dbt = BashOperator(
        task_id='run_dbt_transformation',
        bash_command=f"cd {DBT_DIR} && dbt run --profiles-dir .",
    )

    # 3. Stop NiFi Ingestion (to prevent looping in this batch context)
    stop_nifi = PythonOperator(
        task_id='stop_nifi_ingestion',
        python_callable=change_processor_status,
        op_kwargs={'processor_name': 'GetFile', 'state': 'STOPPED'}
    )

    start_nifi >> run_dbt >> stop_nifi
