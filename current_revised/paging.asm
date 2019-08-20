start_of_page_tables dd 0x10000
page_directory db 0x1000

map_to_identity:
	mov esi, dword [page_directory]
	mov edi, dword [start_of_page_tables]
	or edi, 3
	.dir:
		mov [esi], dword edi
		add edi, 4096
		add esi, 4
		cmp esi, 0x10000+4096
		jb .dir
		mov esi, dword [start_of_page_tables]
		mov edi, 0
	.tables:
		mov [esi], dword edi
		add edi, 4096
		add esi, 4
		cmp esi, 1024*4096+0x1000
		jb .tables
