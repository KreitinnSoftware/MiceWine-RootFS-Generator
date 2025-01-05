libandroid-wordexp.so: wordexp.c wordexp.h
	$(CC) $(CFLAGS) -shared wordexp.c -o libandroid-wordexp.so

install:
	install -Dm600 libandroid-wordexp.so $(DESTDIR)/$(PREFIX)/lib/libandroid-wordexp.so
	install -Dm600 wordexp.h $(DESTDIR)/$(PREFIX)/include/wordexp.h