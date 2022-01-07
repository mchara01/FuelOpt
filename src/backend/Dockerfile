FROM python:3.10.0

RUN apt-get update && apt install tesseract-ocr -y

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["python", "./backend/manage.py", "runserver", "0.0.0.0:8000"]