# cfn-empty-ecr-repository

AWS CloudFormation Custom Resource Lambda to empty an ECR Repository

This project defines a NodeJS Lambda function to back a CloudFormation custom
resource that will delete images from an ECR repository. This allows you to
automatically delete a repository when you delete a stack, as only empty
repositories can be deleted.

## Installing

Prerequisites:

* AWS CLI
* Yarn 1.22 or higher (or `npm`)
* NodeJS 12.x or higher (for adding dummy images to repository)
* Docker (for adding dummy images to repository)

Clone the repository:

    git clone git@github.com:showaltb/cfn-empty-ecr-repository.git
    cd cfn-empty-ecr-repository

Now copy `.env.example` to `.env` and set the following variables:

* `AWS_PROFILE` - AWS CLI profile name
* `AWS_REGION` - AWS region to create the stack in
* `STACK_NAME` - CloudFormation stack to create

Then create the stack:

    yarn deploy

The included stack (`template.yml`) will create the following resources:

* `Repository` - An ECR repository for testing purposes
* `EmptyEcrRepositoryRole` - Lambda execution role giving the function
  permission to list and remove images from the repository.
* `EmptyEcrRepository` - Lambda function for the custom resource to empty the
  repository on delete.
* `RepositoryEmptier` - A custom resource that uses the Lambda function to empty
  the repository on delete.

## Adding Dummy Images to the Repository

You can add dummy images to the repository to test that the repository is
emptied properly when the stack is deleted:

    yarn fill-repository

This will use Docker to build three small `hello-world` images and push them to
the repository. Each image will have a random tag. To push more images, repeat
the command.

## Deleting the Stack

To delete the stack, which will invoke the custom resource to delete any images
in the ECR repository before deleting it:

    yarn delete-stack
