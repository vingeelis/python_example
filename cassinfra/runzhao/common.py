from pathlib import Path


def get_data(file_name, sort: bool = True, field_separator=None):
    file_data = Path(file_name).resolve().stem.__str__() + '.txt'
    with open(file_data) as _fp:
        data = _fp.read()

    data_list = data.split(field_separator)
    if sort:
        return sorted(data_list)
    else:
        return data_list


def get_url(hosts, url='''https://cassinfra.vip.ebay.com/cassinfra/host_fix.html?host={}'''):
    [print(url.format(h)) for h in hosts]
