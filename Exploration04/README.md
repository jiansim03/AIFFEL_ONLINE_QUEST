![image](https://github.com/jiansim03/AIFFEL_ONLINE_QUEST/assets/66249499/1f93e513-3fda-44de-8725-bd95b12cb117)# AIFFEL Campus Online 5th Code Peer Review

- 코더 : 심지안
- 리뷰어 : 서원영

# PRT(PeerReviewTemplate)

- [O] **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
  > 주어진 문제를 잘 해결하였다.
- [] **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된
  주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
  >![image](https://github.com/jiansim03/AIFFEL_ONLINE_QUEST/assets/66249499/1d2abed4-31c9-4297-97d0-80445414c5a4)

  > 각 코드마다 주석이 잘 삭성되어 있어 이해하기 쉬웠다.
- [] **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나”
  ”새로운 시도 또는 추가 실험을 수행”해봤나요?**
  >
- [] **4. 회고를 잘 작성했나요?**

  > 잘 작성되있는걸 확인 하였습니다.

- [] **5. 코드가 간결하고 효율적인가요?**
  > 코드는 충분히 간결하고 효율적으로 느껴졌다.

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
DCGAN의 학습은 판별자와 생성자 사이의 균형이 중요하기 때문에, 둘 중 하나가 너무 강력해지면 문제가 발생할 수 있고 합니다. 이를 해결하기 위에선 다음과 같은 방법이 있습니다.
1) 판별자의 학습률 감소
2) 생성자의 학습률 증가
3) 더 복잡한 모델
4) 라벨 스무딩(Label Smoothing)

이중 라벨스무딩을 적용한 코드를 예시로 남깁니다.

```python
@tf.function
def train_step(images):
    noise = tf.random.normal([BATCH_SIZE, noise_dim])

    with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
        generated_images = generator(noise, training=True)

        real_output = discriminator(images, training=True)
        fake_output = discriminator(generated_images, training=True)

        # 출력하여 형상 확인
        print("Shape of real_output:", real_output.shape)
        print("Shape of fake_output:", fake_output.shape)

        # Soft labels
        real_labels = tf.random.uniform(minval=0.7, maxval=1.2, shape=real_output.shape)
        fake_labels = tf.random.uniform(minval=0.0, maxval=0.3, shape=fake_output.shape)

        # Noisy labels (with a small probability, e.g., 0.05)
        flip_fake = tf.random.uniform(fake_output.shape) < 0.05
        flip_real = tf.random.uniform(real_output.shape) < 0.05
        real_labels = tf.where(flip_real, 1 - real_labels, real_labels)
        fake_labels = tf.where(flip_fake, 1 - fake_labels, fake_labels)


        gen_loss = generator_loss(fake_output)
        disc_loss = discriminator_loss(real_output, fake_output, real_labels, fake_labels)

        real_accuracy, fake_accuracy = discriminator_accuracy(real_output, fake_output) 
    
    gradients_of_generator = gen_tape.gradient(gen_loss, generator.trainable_variables)
    gradients_of_discriminator = disc_tape.gradient(disc_loss, discriminator.trainable_variables)

    generator_optimizer.apply_gradients(zip(gradients_of_generator, generator.trainable_variables))
    discriminator_optimizer.apply_gradients(zip(gradients_of_discriminator, discriminator.trainable_variables))

    return gen_loss, disc_loss, real_accuracy, fake_accuracy
```

이 경우 출력이 실제 출력과 가짜출력 두개이기 때문에 'discriminator_loss' 함수또한 다음과 같이 수정해야 합니다.

```python
import tensorflow as tf
## real_labels와 fake_labels도 함께 전달 받도록 수정
def discriminator_loss(real_output, fake_output, real_labels, fake_labels):
    cross_entropy = tf.keras.losses.BinaryCrossentropy(from_logits=True)
    real_loss = cross_entropy(real_labels, real_output)
    fake_loss = cross_entropy(fake_labels, fake_output)
    total_loss = real_loss + fake_loss
    return total_loss
```
이렇게 하면 함수가 더 유연하게 레이블을 사용하여 손실을 계산할 수 있습니다.

