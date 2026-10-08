{{/*
Expand the name of the chart.
*/}}
{{- define "graphwise-graph-automation-morphkgc.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | replace "_" "-" | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "graphwise-graph-automation-morphkgc.fullname" -}}
  {{- if .Values.fullnameOverride }}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
  {{- else }}
    {{- $name := include "graphwise-graph-automation-morphkgc.name" . }}
    {{- if contains $name .Release.Name }}
      {{- .Release.Name | trunc 63 | trimSuffix "-" }}
    {{- else }}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "graphwise-graph-automation-morphkgc.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "graphwise-graph-automation-morphkgc.labels" -}}
helm.sh/chart: {{ include "graphwise-graph-automation-morphkgc.chart" . }}
{{ include "graphwise-graph-automation-morphkgc.selectorLabels" . }}
app.kubernetes.io/version: {{ coalesce .Values.image.tag .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: graphwise-graph-automation-morphkgc
app.kubernetes.io/part-of: graphwise-graph-automation
{{- if .Values.labels -}}
  {{- tpl (toYaml .Values.labels) . | nindent 0 -}}
{{- end -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "graphwise-graph-automation-morphkgc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "graphwise-graph-automation-morphkgc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "graphwise-graph-automation-morphkgc.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create }}
    {{- default (include "graphwise-graph-automation-morphkgc.fullname" .) .Values.serviceAccount.name }}
  {{- else }}
    {{- default "default" .Values.serviceAccount.name }}
  {{- end }}
{{- end }}

{{/*
Returns the namespace of the release.
*/}}
{{- define "graphwise-graph-automation-morphkgc.namespace" -}}
  {{- .Values.namespaceOverride | default .Release.Namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}
