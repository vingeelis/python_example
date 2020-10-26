racks = '''
SLC03-01-0400-1318
SLC03-01-0400-1012
SLC03-01-0400-1312
SLC03-01-0400-1213
'''.split()


def mget(url_template):
    if '%s' in url_template and '{' in url_template or '}' in url_template:
        for rack in racks:
            print(url_template % rack)
    else:
        for rack in racks:
            print(url_template.format(rack))


url_template = '''https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=Rack[@location="%s"].assets[@assetType="Server"]{@resourceId}.asset!AssetServer{@resourceId,@isAllocated}.nodeServer{@resourceId,@label}.managementServer!AssetServer{*}.nodeServer{@resourceId,@label}.nodeServer!Compute'''
mget(url_template)
url_template = '''https://cmsbrowser.vip.stratus.ebay.com/browser/repo/cmsdb/branch/main/query?query=Rack[@location="%s"].assets{@resourceId}.asset!AssetServer.configuredTo{@resourceId}'''
mget(url_template)
