from transformers import BlipProcessor, BlipForConditionalGeneration, BlipForQuestionAnswering

# BLIP 모델과 프로세서 로드
# model_caption = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")
# processor_caption = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
model_caption = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-large")
processor_caption = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-large")

# model_vqa = BlipForQuestionAnswering.from_pretrained("Salesforce/blip-vqa-base")
# processor_vqa = BlipProcessor.from_pretrained("Salesforce/blip-vqa-base")
model_vqa = BlipForQuestionAnswering.from_pretrained("Salesforce/blip-vqa-capfilt-large")
processor_vqa = BlipProcessor.from_pretrained("Salesforce/blip-vqa-capfilt-large")


# model_caption.save_pretrained('./blip_caption/')
# processor_caption.save_pretrained('./blip_caption/processor/')
model_caption.save_pretrained('./blip_caption_large/')
processor_caption.save_pretrained('./blip_caption_large/processor/')

# model_vqa.save_pretrained('./blip_vqa/')
# processor_vqa.save_pretrained('./blip_vqa/processor/')
model_vqa.save_pretrained('./blip_vqa_capfilt_large/')
processor_vqa.save_pretrained('./blip_vqa_capfilt_large/processor/')