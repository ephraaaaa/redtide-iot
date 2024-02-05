from flask import Flask, jsonify, request, send_file
import subprocess
import json as json
import firebase_admin
from firebase_admin import credentials, auth, db
from flask_cors import CORS
import pandas as pd

cred = credentials.Certificate('D:/repositories/flutter-monitoring-system/red_tide/lib/script/service_account_key/red-tide-monitoring-firebase-adminsdk-62zf1-c136b64011.json')
firebase_admin.initialize_app(cred, {'databaseURL': 'https://red-tide-monitoring-default-rtdb.asia-southeast1.firebasedatabase.app/'})

app = Flask(__name__)
CORS(app)

@app.route('/generate-report', methods=['POST'])
def generate_report():
    try:    
        
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
        excel_file_path = 'C:\Users\Administrator\Downloads'
        df.to_excel(excel_file_path, index=False)
       
        return send_file(excel_file_path, as_attachment=True)
   
   
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/delete-users', methods=['POST'])
def delete_users():
    try:
        data = request.json
        users_to_delete = data.get('users', [])

        for user in users_to_delete:
            uid = user.get('uid', '')
            if uid:
                auth.delete_user(uid)
                print(f"User with UID {uid} deleted from Firebase Auth")

        return jsonify({'message': 'Users deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/generate-users-list')
def generate_user_list():
    users_info=[]
    user_list = auth.list_users()    
    print("List of Signed Users:")
    for user in user_list.users:
        users_info.append({"uid": user.uid, "email": user.email})
        print(f"User UID: {user.uid}, Email: {user.email}")
    try: 
        return jsonify(users_info)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
