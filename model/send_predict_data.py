import firebase_admin
from firebase_admin import credentials, firestore, messaging, auth
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

cred = credentials.Certificate("./opensource2-4d4a1-firebase-adminsdk-c1i8e-bd7a8d9ab8.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()