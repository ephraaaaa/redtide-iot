import firebase_admin
from firebase_admin import credentials, db, auth
import pandas as pd


cred = credentials.Certificate('D:/repositories/flutter-monitoring-system/red_tide/lib/script/service_account_key/red-tide-monitoring-firebase-adminsdk-62zf1-c136b64011.json')
firebase_admin.initialize_app(cred, {'databaseURL': 'https://red-tide-monitoring-default-rtdb.asia-southeast1.firebasedatabase.app/'})
data_ref = db.reference('logs')
data = data_ref.get()
rows = []
for date_key, date_value in data.items():
    for timestamp_key, timestamp_value in date_value.items():
        ph_value = timestamp_value.get('pH', None)
        turbidity_value = timestamp_value.get('turbidity', None)
        rows.append({'date': date_key, 'timestamp': timestamp_key, 'pH': ph_value, 'turbidity': turbidity_value})
df = pd.DataFrame(rows)
print(df)
excel_file_path = 'printable_output_data.xlsx'
df.to_excel(excel_file_path, index=False)
print("File imported to excel.")
try:
    print("Success!")
except Exception as e:
        print(f"Error: {e}")