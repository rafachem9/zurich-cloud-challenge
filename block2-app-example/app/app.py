from flask import Flask, redirect, render_template, request
import boto3
import os
app = Flask(__name__, template_folder='template')

# S3 bucket name
Bucket_Name = 'zurich-data-lake'

# AWS Creds
AWS_ACCESS_KEY = 'fake'
AWS_SECRET_ACCESS_KEY = 'fake'
AWS_REGION = 'us-east-1'
LOCALSTACK_HOST = 'http://localhost:4566'

# S3 Client
s3_client = boto3.client('s3',
                         aws_access_key_id=AWS_ACCESS_KEY,
                         aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
                         region_name=AWS_REGION,
                         endpoint_url=LOCALSTACK_HOST)


# Index route
@app.route('/')
def index():
    print(os.getcwd())
    return render_template("index.html")


# Upload route
@app.route('/upload', methods=['POST'])
def upload():
    if 'image' not in request.files:
        return 'No image selected', 400
    
    image = request.files['image']

    # Store image in S3 bucket
    s3_client.upload_fileobj(image, Bucket_Name, image.filename)

    return 'Image upload successfully'


@app.route('/supersecret')
def secret():
    video_url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'  
    return redirect(video_url)


if __name__ == '__main__':
    app.run()
