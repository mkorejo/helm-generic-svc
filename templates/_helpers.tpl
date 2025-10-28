{{/*
Expand the name of the chart.
*/}}
{{- define "fia-svc.name" -}}
{{- $name := default .Chart.Name .Values.name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fia-svc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fia-svc.labels" -}}
helm.sh/chart: {{ include "fia-svc.chart" . }}
{{ include "fia-svc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fia-svc.selectorLabels" -}}
app: {{ include "fia-svc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fia-svc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fia-svc.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Derive short-form AWS region code
*/}}
{{- define "fia-svc.region" -}}
{{- $regionCode := "" }}
{{- if eq .Values.awsRegion "us-east-1" }}
{{- $regionCode = "use1" }}
{{- else if eq .Values.awsRegion "us-east-2" }}
{{- $regionCode = "use2" }}
{{- else if eq .Values.awsRegion "us-west-1" }}
{{- $regionCode = "usw1" }}
{{- else if eq .Values.awsRegion "us-west-2" }}
{{- $regionCode = "usw2" }}
{{- end }}
{{- print $regionCode }}
{{- end }}

{{/*
Add common configuration values to application-specific configurations.
For example: AWS Account ID, AWS Region, Tier, Customer Name/Prefix, and timezone.
*/}}
{{- define "fia-svc.config" -}}
{{- $consolidatedConfig := merge .Values.config (dict "awsAccountID" .Values.awsAccountID "awsRegion" .Values.awsRegion "customer" .Values.customer "tenant" .Values.customer "configTier" .Values.tier "tier" .Values.tier) | toJson }}
{{- print $consolidatedConfig }}
{{- end }}
