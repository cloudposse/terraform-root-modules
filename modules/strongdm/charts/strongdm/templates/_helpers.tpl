{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sdm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sdm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sdm.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{/*
Normally we would expect the Release.Name to include the chart name, but this is a multi-chart
*/}}
{{- if or (contains $name .Release.Name) (contains "sdm-" .Release.Name) -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "sdm.labels" -}}
helm.sh/chart: {{ include "sdm.chart" . }}
{{ include "sdm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Affinity labels
*/}}
{{- define "sdm.affinityLabels" -}}
app.kubernetes.io/name: "{{ include "sdm.name" . }}"
{{- end -}}

{{/*
Affinity matchExpression
*/}}
{{- define "sdm.affinityMatchExpressions" -}}
- key: "app.kubernetes.io/name"
  operator: In
  values:
  - "{{ include "sdm.name" . }}"
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "sdm.selectorLabels" -}}
{{ include "sdm.affinityLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "sdm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "sdm.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

