{{/*
Expand the name of the chart.
*/}}
{{- define "janusgraph.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 46 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec) with a 17-character reservation for the component
name. If release name contains chart name it will be used as a full name.
*/}}
{{- define "janusgraph.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 46 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 46 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 46 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "janusgraph.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "janusgraph.selectorLabels" -}}
app.kubernetes.io/app-instance: {{ .Release.Name }}
app.kubernetes.io/feature: "janusgraph"
component: janusgraph
owner: dbap
{{- end }}

{{/*
Common labels
*/}}
{{- define "janusgraph.labels" -}}
app.kubernetes.io/product-line: infra
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
customer-facing: "false"
environment: {{ .Values.global.s1.env }}
service-repository: janusgraph
engineering-org: cloud-eng
product-org: cloud-eng
{{ include "janusgraph.selectorLabels" . }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "janusgraph.podLabels" -}}
{{ include "janusgraph.labels" . }}
scalyr-parser: json
scalyr-team: shared-services-kafka
{{- end }}

{{- define "helmCreateJanusgraphPasswordSecretName" -}}
{{- if eq .Values.global.s1.cloud "aws" }}
{{- printf "%s/%s/dbap/janusgraph/%s-creds" .Values.global.s1.region .Values.global.s1.env .Release.Name }}
{{- else }}
{{- printf "%s_%s_%s-creds" .Values.global.s1.region .Values.global.s1.env .Release.Name }}
{{- end }}
{{- end }}

{{- define "cassandraAddr" -}}
{{- if .Values.cassandra.externalAddr }}
{{- print .Values.cassandra.externalAddr }}
{{- else }}
{{- print .Release.Name "-dc1-service " }}
{{- end }}
{{- end }}

{{- define "opensearchAddr" -}}
{{- if .Values.opensearch.externalAddr }}
{{- print .Values.opensearch.externalAddr }}
{{- else }}
{{- print .Values.opensearch.openSearchClusterName "-coordinator" }}
{{- end }}
{{- end }}
