from openai import OpenAI
client = OpenAI()

completion = client.chat.completions.create(
  model="gpt-4o-mini",
  messages=[
    {"role": "system", "content": "너는 의성어와 의태어를 적극적으로 사용하는 유아 전문 동화작가야."},
    {"role": "user", "content": "'a plate of spaghetti with tomato sauce and basil'를 주제로 하는 동화 이야기를 만들어줘."}
  ]
)

print(completion.choices[0].message.content)