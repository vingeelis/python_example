from html.parser import HTMLParser


class CronusParse(HTMLParser):
    def handle_startendtag(self, tag, attrs):
        print("Encountered a start tag: ", tag)

    def handle_endtag(self, tag):
        print("Encountered an end tag: ", tag)

    def handle_data(self, data):
        print("Encountered some data: ", data)


parser = CronusParse()
# parser.feed(open('./cronus.html').read())
html = '''<table>
    <tr>
        <td> Version </td>
        

        <td>
                1.1.74 <br />
        </td>
    </tr>
</table>'''
parser.feed(html)