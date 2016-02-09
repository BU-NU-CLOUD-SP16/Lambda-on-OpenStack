from os import environ as env
def get_nova_credentials_v2():
    d = {}
    d['version'] = '2'
    d['username'] = env['OS_USERNAME']
    d['api_key'] = env['OS_PASSWORD']
    d['auth_url'] = env['OS_AUTH_URL']
    d['project_id'] = env['OS_TENANT_NAME']
    return d