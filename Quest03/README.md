# AIFFEL Campus Online 5th Code Peer Review Templete
- 코더 : 심지안
- 리뷰어 : 신지만


# PRT(PeerReviewTemplate) 
각 항목을 스스로 확인하고 토의하여 작성한 코드에 적용합니다.

- [X] 코드가 정상적으로 동작하고 주어진 문제를 해결했나요?
  > 정상적으로 동착하고 원하는 결과를 출력합니다.   
  > [('it s', 68), ('i m', 52), ('don t', 43), ('you re', 35), ('the tesseract', 34)]
  
- [ ] 주석을 보고 작성자의 코드가 이해되었나요?
  > 각 함수 및 코드에 대한 설명이 아주 자세해 코드를 이해하기 쉽습니다.
- [ ] 코드가 에러를 유발할 가능성이 없나요?
  > 툭이 사항은 없는 듯합니다.
- [ ] 코드 작성자가 코드를 제대로 이해하고 작성했나요?
  > collections 모듈을 사용해 문제를 푼 것으로 미루어 문제를 잘 이해하고 코드를 작성한 것으로 여깁니다.
- [ ] 코드가 간결한가요?
  > collections 모듈 사용으로 코드가 아주 간결합니다.

# 예시
1. 코드의 작동 방식을 주석으로 기록합니다.
2. 코드의 작동 방식에 대한 개선 방법을 주석으로 기록합니다.
3. 참고한 링크 및 ChatGPT 프롬프트 명령어가 있다면 주석으로 남겨주세요.
```python
# 06TheAvengers.txt 파일을 사용한다.
import re
from collections import Counter
# re 모듈과 collections 모듈을 가져옴.

file = open("/content/sample_data/Avengers.txt", "r")

contents = file.read()
file.close()


def process_text(text):
  text = re.sub(r'[^\w\s]',' ',text)      # 정규 표현식을 사용하여 특수 문자를 제거함.
  text = text.lower()                    # lower()를 이용해서 대문자를 소문자로 변환함
  return text

# 제러레이터 생성해서 단어 자른다
def gen_ngram(text, n):
  words = text.split()                   # 텍스트를 단어로 자름
  ngrams = []
  for i in range(len(words) - n + 1):    # 각 단어를 포함하는 n-gram 생성
    ngram = ' '.join(words[i:i+n])       # 공백을 기준으로 단어를 결합하여 n-gram을 생성함
    ngrams.append(ngram)                 # 생성된 n-gram을 리스트에 추가
  return ngrams



processed_text = process_text(contents) # 파일 가져오기

ngrams = gen_ngram(processed_text, 2)   # 2-gram 생성

ngrams_count = Counter(ngrams)          # 2-gram의 빈도 계산

most_ngram = ngrams_count.most_common(5)  # 가장 빈도가 높은 5개의 2-gram을 반환

print(most_ngram)





```

# 참고 링크 및 코드 개선
```python
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
> collections 모듈 설명 ChatGPT 활용
https://chat.openai.com/share/827e2523-748a-45f9-adf3-cfc4fd6126cb
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
