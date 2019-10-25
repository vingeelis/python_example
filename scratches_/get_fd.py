# query = '''FQDN[@resourceId="%s"].hostName!NodeServer.nodeServer!AssetServer{@faultDomain}'''
query = '''FQDN[@resourceId="{}"].hostName!NodeServer.nodeServer!AssetServer{{@faultDomain}}'''


with open('hosts_to_add') as hosts:
    # list([print(query % (host.rstrip())) for host in hosts])
    list([print(query.format(host.rstrip())) for host in hosts])

