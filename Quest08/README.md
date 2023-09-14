# AIFFEL Campus Online 5th Code Peer Review Templete
### 뉴스기사 요약#
- 코더 : 심지안
- 리뷰어 : 서원


# PRT(PeerReviewTemplate) 
각 항목을 스스로 확인하고 토의하여 작성한 코드에 적용합니다.

- [V] 코드가 정상적으로 동작하고 주어진 문제를 해결했나요?
  - 코드가 정상적으로 동작하고 추출적 요약을 제외하면 정상적으로 잘 동작 했습니다.
- [V] 주석을 보고 작성자의 코드가 이해되었나요?
  > 네 잘 이해가 되었습니다.
- [V] 코드가 에러를 유발할 가능성이 없나요?
  > 제시된 코드에서는 에러를 유발할 가능성을 찾아볼 수 없었습니다.
- [V] 코드 작성자가 코드를 제대로 이해하고 작성했나요?
  > 제대로 이해하고 작성한 것으로 보입니다.
- [V] 코드가 간결한가요?
  > 보고 이해하기 쉽게 간결하게 작성되어 있습니다.

# 예시
1. 코드의 작동 방식을 주석으로 기록합니다.
2. 코드의 작동 방식에 대한 개선 방법을 주석으로 기록합니다.
3. 참고한 링크 및 ChatGPT 프롬프트 명령어가 있다면 주석으로 남겨주세요.
```python
# 사칙 연산 계산기
class calculator:
    # 예) init의 역할과 각 매서드의 의미를 서술
    def __init__(self, first, second):
        self.first = first
        self.second = second
    
    # 예) 덧셈과 연산 작동 방식에 대한 서술
    def add(self):
        result = self.first + self.second
        return result

a = float(input('첫번째 값을 입력하세요.')) 
b = float(input('두번째 값을 입력하세요.')) 
c = calculator(a, b)
print('덧셈', c.add()) 
```

# 참고 링크 및 코드 개선
```python
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```

추출적 요약을 진행하시지 못한것으로 보입니다. 아래 제가 작성한 추출성 요약 코드와 간단한 설명을 남깁니다.

import requests
from summa.summarizer import summarize

# 데이터 로드
data = pd.read_csv('news_summary_more.csv', encoding='iso-8859-1')

# 'text' 열에서 데이터를 추출적 요약하여 출력
for idx, text in enumerate(data['text']):
    print(f"Original Text {idx + 1}:\n{text}\n")
    print(f"Summarized Text {idx + 1}:\n{summarize(text, ratio=0.5)}\n")
    print("-"*100)

# 출력 길이를 조정
    if idx == 4:
        break

  데이터 로드를 다시 하는 이유는 기존에 전처리한 데이터로 summarized 진행시 함수가 이미 텍스트가 충분히 요약이 되어있다고 판단해 빈 문자열을 반환하기 때문입니다. 때문에 새로 데이터를 불러와 텍스트 열만을 추출하여 for문을 이용 summarized를 진행합니다.
