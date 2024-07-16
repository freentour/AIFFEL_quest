from tensorflow.keras.applications.vgg16 import VGG16

model = VGG16(weights='imagenet', include_top=True)
# model.compile(optimizer='adam', loss='categorical_crossentropy')
model.summary()

model.save('vgg16.h5')
# model.save('vgg16.keras')