#!/bin/sh

# push three small "hello world" images to the ECR repository for testing

. ./.env

export AWS_PROFILE
export AWS_REGION

account=$(aws sts get-caller-identity \
  --query 'Account' \
  --output text)
server=${account}.dkr.ecr.${AWS_REGION:-us-east-1}.amazonaws.com

repository=$(aws cloudformation describe-stack-resource \
  --stack-name $STACK_NAME \
  --logical-resource-id Repository \
  --query 'StackResourceDetail.PhysicalResourceId' \
  --output text)
image=${server}/${repository}

aws ecr get-login-password | docker login --username AWS --password-stdin $server

echo "FROM hello-world\nCOPY tag.temp /" >Dockerfile
cp .gitignore .dockerignore

for i in 1 2 3
do
  tag=$(node -p -e 'Math.floor(Math.random() * 2**32).toString(16)')
  echo $uuid >tag.temp
  docker build -t $image:$tag .
  docker push $image:$tag
  docker rmi $image:$tag
done

rm -f Dockerfile tag.temp .dockerignore
