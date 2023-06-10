import firebase_admin
from firebase_admin import credentials, firestore, messaging, auth
import pandas as pd
from sklearn.ensemble import RandomForestClassifier

cred = credentials.Certificate("./opensource2-4d4a1-firebase-adminsdk-c1i8e-bd7a8d9ab8.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()

def predict_voracity(doc) -> int:
    data_df = pd.read_csv('./data.csv')

    train_X = data_df.drop(['DATE','voracity'], axis=1)
    train_Y = data_df['voracity']
    doc_df = pd.DataFrame(doc, index=[0], columns=train_X.columns)
