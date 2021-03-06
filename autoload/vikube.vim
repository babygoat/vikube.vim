
fun! vikube#kubectl_ns(action, namespace, ...)
  return printf("kubectl %s --namespace=%s ", a:action, a:namespace) . join(a:000, ' ')
endf

fun! vikube#get_deployment_pod_containers(namespace, pod)
  let tmpl = '{{range .spec.template.spec.initContainers}}{{.name}}{{"\n"}}{{end}}{{range .spec.template.spec.containers}}{{.name}}{{"\n"}}{{end}}'
  let cmd = "kubectl get --namespace=" . a:namespace . ' pod ' . a:pod . " -o=go-template --template '" . tmpl . "'"
  let out = system(cmd)
  return split(out)
endf

fun! vikube#get_pod_containers(namespace, pod)
  let tmpl = '{{range .spec.initContainers}}{{.name}}{{"\n"}}{{end}}{{range .spec.containers}}{{.name}}{{"\n"}}{{end}}'
  let cmd = "kubectl get --namespace=" . a:namespace . ' pod ' . a:pod . " -o=go-template --template '" . tmpl . "'"
  let out = system(cmd)
  return split(out)
endf

fun! vikube#get_current_context()
  return split(system("kubectl config current-context"))[0]
endf

fun! vikube#get_namespaces()
  return split(system("kubectl get namespace --no-headers | awk '{ print $1 }'"))
endf

function! vikube#get_current_namespace()
    return system('kubectl config view -o=jsonpath="{.contexts[?(@.name==\"$(kubectl config current-context)\")].context.namespace}"')
endfunction

