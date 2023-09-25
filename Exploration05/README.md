# AIFFEL Campus Online 5th Code Peer Review

- 코더 : 심지안
- 리뷰어 :박근수

# PRT(PeerReviewTemplate)

- [X] **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
  > 한국어 데이터 셋을 통해서 챗봇이 잘 작동하는 것을 확인했습니다.
  > 루브릭 3개 중 3개 모두 만족하였습니다.
  > 1. 한국어 전처리를 통해 학습 데이터셋을 구축하였다. (OK)
   -  공백과 특수문자 처리, 토크나이징, 병렬데이터 구축의 과정이 적절히 진행되었다.
  > 2. 트랜스포머 모델을 구현하여 한국어 챗봇 모델 학습을 정상적으로 진행하였다.(OK)
   - 구현한 트랜스포머 모델이 한국어 병렬 데이터 학습 시 안정적으로 수렴하였다.
  > 3. 한국어 입력문장에 대해 한국어로 답변하는 함수를 구현하였다.(OK)
   - 한국어 입력문장에 맥락에 맞는 한국어로 답변을 리턴하였다.
  Output 결과

  ```
  sentence_generation('갈까 말까?')
  입력 : 갈까 말까?
  출력 : 가세요 .
  '가세요 .'
  sentence_generation('기름값 올랐어.')
  입력 : 기름값 올랐어.
  출력 : 대중교통을 이용해주세요 .
  '대중교통을 이용해주세요 .'
  sentence_generation('가을 타나 봐.')
  입력 : 가을 타나 봐.
  출력 : 혼자는 외로운 계절이죠 .
  '혼자는 외로운 계절이죠 .'
  ```
  
- [X] **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된
  주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
  > 모든 코드 블럭에 상세한 주석이 적혀 있어 잘 이해됨
  > 
- [X] **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나”
  ”새로운 시도 또는 추가 실험을 수행”해봤나요?**
  > 훈련과정을 history객체에 담아 Loss와 정확도를 기록하여 그래프로 나타내었다
  > ![image](https://github.com/jiansim03/AIFFEL_ONLINE_QUEST/assets/76907850/540494ca-c888-4ab6-9e76-3fcda89ddd5e)

- [X] **4. 회고를 잘 작성했나요?**

  > KPT 양식으로 느낀점과 문제점, 할일을 잘 작성하였다.
  ```
  KEEP
  말로만 듣던 transformer모델... 이름에 걸맞게 RNN 모델들을 모두 집약해 놓은 느낌이었다 단어와 단어간의 유사도를 단어 벡터로부터 구하는 어텐션의 개념이 흥미로웠다

  PROBLEM
  이전에 배운 RNN 개념들이 약한것이 느껴졌다

  TRY
  이전 노드들을 복습해야겠다
  ```
- [X] **5. 코드가 간결하고 효율적인가요?**
  > 전체적으로 파이썬 스타일 가이드를 잘 따르고 있음
  > 한가지 수정사항은 불필요한 import가 있음. 예를 들어, os는 두 번 불러와져 있어 중복된 import 제거 필요함
  > PositionalEncoding 클래스 내의 함수들 사이에 빈 줄이 없음. 함수들 사이에는 한 줄의 공백을 두는 것이 일반적인 스타일 가이드를 따르는 것임.


# 참고 링크 및 코드 개선

```python
# 한글로 변경된 주석과 노트를 포함한 수정 코드

# 1. 중복된 import 문제 제거
import tensorflow as tf
import tensorflow_datasets as tfds
import os
import re
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# 2. 클래스와 함수 사이, 함수 내부의 로직들 사이에 공백 라인 추가로 가독성 향상

class PositionalEncoding(tf.keras.layers.Layer):

    def __init__(self, position, d_model):
        super(PositionalEncoding, self).__init__()
        self.pos_encoding = self.positional_encoding(position, d_model)

    def get_angles(self, position, i, d_model):
        angles = 1 / tf.pow(10000, (2 * (i // 2)) / tf.cast(d_model, tf.float32))
        return position * angles

    def positional_encoding(self, position, d_model):
        # 기존의 로직 ...

    def call(self, inputs):
        return inputs + self.pos_encoding[:, :tf.shape(inputs)[1], :]

# ... (나머지 코드도 유사한 방식으로 수정 필요)

# 참고: 위의 코드는 수정 사항을 보여주기 위한 예시입니다. 실제로 실행하면 오류가 발생할 수 있습니다. 
# 제안된 수정 사항을 전체 코드에 적용하려면 유사한 방식으로 코드를 수정해야 합니다.

```
