resources:
  - apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ${ server_name }
      labels:
        app: ${ server_name }
        category: maintenance
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: ${ server_name }
          category: maintenance
      template:
        metadata:
          name: ${ server_name }
          labels:
            app: ${ server_name }
            category: maintenance
          annotations:
            reloader.stakater.com/auto: "true"
        spec:
          containers:
          - name: ${ server_name }
            image: quay.io/sdmrepo/client:latest
            imagePullPolicy: IfNotPresent
            command: [ "/etc/strongdm/sdm-cleanup" ]
            args:
            - "${ cleanup_period_seconds }"
            - "${ max_unhealthy_per_run }"
            env:
            - name: SDM_ADMIN_TOKEN
              valueFrom:
                secretKeyRef:
                  name: sdm-node
                  key: token
            resources:
              limits:
                memory: 64Mi
                cpu: 50m
              requests:
                memory: 16Mi
                cpu: 50m
            volumeMounts:
            - name: config
              mountPath: /etc/strongdm
          terminationGracePeriodSeconds: 5
          volumes:
          - name: config
            configMap:
              name: sdm-cleanup
              defaultMode: 0777
  - apiVersion: v1
    kind: ConfigMap
    metadata:
      name: sdm-cleanup
    data:
      sdm-cleanup: ${ sdm_cleanup }
  - apiVersion: policy/v1beta1
    # A PodDisruptionBudget is necessary for deployments in the `kube-system` namespace in order
    # to allow the pod to be moved and the node to be shut down.
    # See https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#what-types-of-pods-can-prevent-ca-from-removing-a-node
    # We use a PodDisruptionBudget rather than an annotation so that other auto scalers,
    # such as the Spotinst Ocean Controller, are more likely to take it into account.
    kind: PodDisruptionBudget
    metadata:
      name: sdm-cleanup
    spec:
      maxUnavailable: "50%"
      selector:
        matchLabels:
          app: ${ server_name }
          category: maintenance
