# tf-module-eks
Terraform module for creating EKS resources

module to deploy an eks cluster

This module deploys the following resources:

* [aws_eks_addon](https://registry.terraform.io/providers/hashicorp/aws/6.3.0/docs/resources/eks_addon)
* [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.3.0/docs/resources/eks_cluster)
* [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/6.3.0/docs/resources/eks_node_group)

It is still very much work in progress, 

this module will support:

* eks with automatically managed node groups
* eks with aws managed node groups

eks with aws managed node groups, if you wish to use launch_templates with this deployment then please build with the launch template module, which is not created yet :)

this is a different approach to the eks module on the registry, the intent is to break up the one gigantic monolothic module,
into smaller maneagable modules. 

the modules will be as follows:

* [tf-eks-access](https://github.com/vamegh/tf-eks-access.git)
* [tf-eks-cluster](https://github.com/vamegh/tf-eks-cluster.git)
* [tf-eks-ec2-launch](https://github.com/vamegh/tf-eks-ec2-launch.git) - wip

an example deployment is provided here:

* [tf-deploy-eks](https://github.com/vamegh/tf-deploy-eks.git)

There are a few extra modules that deploy all of the various other components, this is still very much work in progress. 

 
