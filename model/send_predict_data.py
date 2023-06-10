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
    
    rf = RandomForestClassifier()
    rf.fit(train_X, train_Y)
    res = rf.predict(doc_df)
    return res


def send_prediction_data():
    ref = db.collection('data')
    docs = ref.get()    
    df = pd.read_csv('./data.csv')

    for doc in docs:
        date = doc.to_dict()['DATE']
        if date not in list(df['DATE']):
            predict_result = predict_voracity(doc.to_dict())
            if predict_result:
                title="폭식 위험!"
                body="Sad.."
            else:
                title="좋은 하루입니다!"
                body="Good!"
            message = messaging.Message(
                    notification=messaging.Notification(
                        title=title,
                        body=body,
                    ),
                    token="your private token"
            )
            result = messaging.send(message)
            print(result)
            break

if __name__ == '__main__':
    send_prediction_data()