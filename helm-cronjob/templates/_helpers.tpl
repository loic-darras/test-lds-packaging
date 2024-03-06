{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "helm-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create object labels
*/}}
{{- define "helpers.labels" }}
{{- include "common-helpers.labels" .  }}
aap.adeo.cloud/component-name: {{ template "helm-api.name" . }}
app: {{ template "helm-api.name" . }}
{{- include "common-helpers.custom-labels" .Values.component.labels  }}
{{- end }}

{{/*
Create object annotations
*/}}
{{- define "helpers.annotations" }}
{{- include "common-helpers.annotations" .  }}
aap.adeo.cloud/component-name: {{ template "helm-api.name" . }}
{{- include "common-helpers.custom-annotations" .Values.component.annotations  }}
{{- end }}

{{/*
Configure container lifecycle
 */}}
{{- define "helpers.lifecycle" }}
{{- if .lifecycle }}
lifecycle:
{{- if .lifecycle.postStart }}
  postStart:
    exec:
      command:
      {{- range $key, $token := .lifecycle.postStart.command.tokens }}
      - '{{ $token }}'
      {{- end }}
{{- end }}
{{- if .lifecycle.preStop }}
  preStop:
    exec:
      command:
      {{- range $key, $token := .lifecycle.preStop.command.tokens }}
      - '{{ $token }}'
      {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Configure startupProbe, readiness and  liveness
 */}}
{{- define "helpers.probes" }}
{{- /* Configure startup */ -}}
{{- if .startupProbe }}
startupProbe:
{{- include "helpers.probeValues" (dict "probe" .startupProbe "ports" .ports ) | indent 2 }}
{{- end}}
{{- /* Configure readiness */ -}}
{{- if .readinessProbe }}
readinessProbe:
{{- include "helpers.probeValues" (dict "probe" .readinessProbe "ports" .ports ) | indent 2 }}
{{- end}}
{{- /* Configure liveness */ -}}
{{- if .livenessProbe }}
livenessProbe:
{{- include "helpers.probeValues" (dict "probe" .livenessProbe "ports" .ports ) | indent 2 }}
{{- end}}

{{- end}}



{{- define "helpers.probeValues" }}
{{- /* Configure httpGet */ -}}
{{- if kindIs "map" .probe.httpGet }}
  httpGet: 
{{- if (omit .probe.httpGet "port")  }}
{{ omit .probe.httpGet "port" | toYaml | indent 4 }}
{{- end }}
    port: {{ .probe.httpGet.port |  default .ports.admin | default .ports.main }}
{{- end }}
{{- /* Configure exec probe */ -}}
{{- if .probe.exec }}
  exec:
{{ toYaml .probe.exec | indent 4 }}
{{- end }}
{{- /* Configure grpc probe */ -}}
{{- if .probe.grpc }}
  grpc:
{{ toYaml .probe.grpc | indent 4 }}
{{- end}}
{{- /* Configure tcp probe */ -}}
{{- if .probe.tcpSocket }}
  tcpSocket:
{{ toYaml .probe.tcpSocket | indent 4 }}
{{- end}}
{{- /* Configure probe commons config  */ -}}
{{- if (omit .probe "httpGet" "grpc" "exec" "tcpSocket")  }}
{{ omit .probe "httpGet" "grpc" "exec" "tcpSocket" | toYaml | indent 2  }}
{{- end }}
{{- end}}

{{/*
Configure kong plugins for an ingress route
parameters:
  dot: the values file
  routeKey: the ingress route key
  route: the ingress route
 */}}
{{- define "helm-api.ingress.kongPlugins" -}}
  {{- $kongPlugins := list -}}
  {{- $ingressName := printf "%s-%s" (include "helm-api.name" .dot) .routeKey -}}
  {{- $appName := include "helm-api.name" .dot }}

  {{- $keyAuthEnabled := true -}}
  {{- if and .route.policies .route.policies.keyAuth (not .route.policies.keyAuth.enabled) -}}
    {{- $keyAuthEnabled = false -}}
  {{- end -}}
  {{- if $keyAuthEnabled -}}
    {{- $kongPlugins = append $kongPlugins (printf "%s-%s" $appName "key-auth-plugin") -}}
  {{- end -}}

  {{- if $kongPlugins -}}
    konghq.com/plugins: {{ join "," $kongPlugins | quote -}}
  {{- end -}}
{{- end -}}
