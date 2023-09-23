provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "my-kind-cluster"  # Use the context created by Kind
  load_config_file = false
}

resource "kubectl_manifest" "test" {
  yaml_body = <<YAML
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: express-app-deployment
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: express-app
    template:
      metadata:
        labels:
          app: express-app
      spec:
        containers:
          - name: express-app-container
            image: rasheed0apampa/express_app
            ports:
              - containerPort: 3000
  YAML
}
