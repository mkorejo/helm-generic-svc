# fia-svc

This is a reusable Helm chart for deploying workloads to Kubernetes. Based on the contents of `values.yaml`, different types of workloads can be deployed. The following is supported:

- Typical `Deployment`, `Service`, and `Ingress` pattern
- `Job` and `CronJob` workloads
- Autoscaling with `HorizontalPodAutoscaler`
- Ability to define extra environment variables, volumes, annotations and labels, etc.
- Ability to define arbitrary configuration and embed in a `ConfigMap`
- Ability to specify custom K8s roles

## Usage

1. Ensure you have a GitLab project for your container image build which includes a `.gitlab-ci.yml` for building and publishing your image(s) to AWS ECR.
1. Create a `values.yaml` (or multiple representing different environments) in your own GitLab project. [Examples](./examples/) are embedded in this chart for getting started easily.
1. Engage the IT Platform team for onboarding yourself and your application to GitOps.

## Example Values

### Deployment

See [webapp.values.yaml](./examples/webapp.values.yaml) for an example of deploying a typical always-on workload via a Kubernetes `Deployment`, `Service`, and `Ingress`. This is the default configuration of the Helm chart.

### Job or CronJob

See [batch.values.yaml](./examples/batch.values.yaml) for an example of deploying a K8s Job or CronJob:

- `deployment.enabled` must be false
- `job.enabled` must be true
- `job.image.repository` and `job.image.tag` define the repository URL and image tag
- Including a cron expression in `job.cronSchedule` will deploy a `CronJob`
