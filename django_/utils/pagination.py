from django.utils.safestring import mark_safe


class Page:
    def __init__(self, current_page, n_items, n_items_per_page=10, n_items_in_pagerbar=11):
        self.current_page = current_page
        self.n_items = n_items
        self.n_items_per_page = n_items_per_page
        self.n_items_in_pagerbar = n_items_in_pagerbar

    @property
    def start(self):
        return (self.current_page - 1) * self.n_items_per_page

    @property
    def end(self):
        return self.current_page * self.n_items_per_page

    @property
    def n_pages(self):
        v, y = divmod(self.n_items, self.n_items_per_page)
        if y:
            v += 1
        return v

    def pager_index(self):

        start_index = 1
        end_index = self.n_pages

        print(start_index, end_index)
        return int(start_index), int(end_index) + 1

    # def pager_index(self):
    #     if self.n_pages < self.n_items_in_pagerbar:
    #         start_index = 1
    #         end_index = self.n_pages + 1
    #     else:
    #         if self.current_page <= (self.n_items_in_pagerbar + 1) / 2:
    #             start_index = 1
    #             end_index = self.n_items_in_pagerbar + 1
    #         else:
    #             start_index = self.current_page - (self.n_items_in_pagerbar - 1) / 2
    #             end_index = self.current_page + (self.n_items_in_pagerbar + 1) / 2
    #             if (self.current_page + (self.n_items_in_pagerbar - 1) / 2) > self.n_pages:
    #                 start_index = self.n_pages - self.n_items_in_pagerbar + 1
    #                 end_index = self.n_pages + 1
    #     return start_index, end_index

    def page_str(self, base_url):
        page_list = []
        start_index, end_index = self.pager_index()

        if self.current_page == 1:
            prev = '<a class="page" href="javascript:void(0);">prev</a>'
        else:
            prev = f'<a class="page" href="{base_url}?p={self.current_page - 1}">prev</a>'
        page_list.append(prev)

        for i in range(int(start_index), int(end_index)):
            if i == self.current_page:
                page_a = '<a class="page active" href="%s?p=%s">%s</a>' % (base_url, i, i)
            else:
                page_a = '<a class="page" href="%s?p=%s">%s</a>' % (base_url, i, i)
            page_list.append(page_a)

        if self.current_page == self.n_pages:
            next = '<a class="page" href="javascript:void(0);">next</a>'
        else:
            next = f'<a class="page" href="{base_url}?p={self.current_page + 1}">next</a>'
        page_list.append(next)

        jump = """
        <input type='text'  /><a onclick='jumpTo(this, "%s?p=");'>GO</a>
        <script>
            function jumpTo(self,base){
                var val = self.previousSibling.value;
                location.href = base + val;
            }
        </script>
        """ % (base_url,)

        page_list.append(jump)

        page_str = mark_safe(" ".join(page_list))

        return page_str
