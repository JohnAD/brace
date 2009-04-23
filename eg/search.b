#!/lang/b
use b

Main()
	http_fake_browser(1)
	eacharg(a)
		cstr query = url_encode(a)
		cstr url = format("http://www.google.com/search?name=f&hl=en&q=%s", query)
		Free(query)

		new(b, buffer, 1024)

		http_get(url, b)
		Free(url)

		new(b_split, buffer, 1024)

		b_io(b, b_split)
			html_split()

		buffer_free(b)

		new(v, vec, search_results, 10)
		b_in(b_split)
			eachline(s)
				if cstr_begins_with(s, "<a ") && strstr(s, " class=l")
					cstr href = Strchr(s, '"')+1;
					*Strchr(href, '"') = '\0';
					new(title, buffer, 64)
					new(desc, buffer, 128)
					b_out(title)
						repeat
							cstr s = rl()
							if !s || cstr_eq(s, "</a>")
								break
							if s[0] != '<'
								print(s)
					b_out(desc)
						repeat
							cstr s = rl()
							if !s || cstr_eq(s, "<div class=\"s\">")
								break
						repeat
							cstr s = rl()
							if !s || cstr_eq(s, "<br>")
								break
							if s[0] != '<'
								print(s)
					vec_push(v, (search_results){ .href = strdup(href), .title = buffer_to_cstr(title), .desc = buffer_to_cstr(desc) })
#					sf("%s\t%s\t%s", href, buffer_to_cstr(title), buffer_to_cstr(desc))
#					buffer_free(title)
#					buffer_free(desc)

		buffer_free(b_split)

		for_vec(i, v, search_results)
			sf("url:\t%s", i->href)
			sf("title:\t%s", i->title)
			sf("desc:\t%s", i->desc)

			i->html = http_get(i->href)
			i->text = html2text(i->html)
			cstr_dos_to_unix(i->text)

			say("text:")

			decl(b_text, buffer)
			buffer_from_cstr(b_text, i->text)
			b_in(b_text)
				eachline(s)
					sf("\t%s", s)

			say()

			say("html:")

			decl(b_html, buffer)
			buffer_from_cstr(b_html, i->html)
			b_in(b_html)
				eachline(s)
					sf("\t%s", s)

			say()

struct search_results
	cstr href
	cstr title
	cstr desc
	cstr html
	cstr text
