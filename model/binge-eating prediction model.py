import pandas as pd
from sklearn.model_selection import train_test_split

data = pd.read_csv('.\data.csv') #경로 바탕화면에 있다고 가정

# 데이터를 예측을 위한 값, 정답 값이랑 분리 -> 다른 값이랑 폭식 값이랑
X_data = data.drop("voracity", axis=1) # 폭식줄만 빼고 반환
y_data = data.loc[:, "voracity"] # 전체에서 폭식줄만 가져와라
# 데이터를 학습데이터랑 테스트 데이터랑 분리해줘야 함 (80, 20)
train_X, test_X, train_y, test_y = train_test_split(X_data, y_data, test_size=0.2) #8대2로 나누어준다는 뜻

from sklearn.ensemble import RandomForestClassifier

# Random Forest 모델 생성
rf = RandomForestClassifier()

# 모델 훈련
rf.fit(train_X, train_y)

from sklearn.metrics import accuracy_score

# 테스트 세트로 예측
y_pred = rf.predict(test_X) #test_X에 사용자의 데이터를 입력하는 부분이 되는 것

# 정확도 평가
accuracy = accuracy_score(test_y, y_pred)
print("Accuracy:", accuracy)