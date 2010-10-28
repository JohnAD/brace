# this isn't exactly a core library!
# but if I want to use it in more than one program, it goes in

def hunk(in_file, out_dir)
	hunk(in_file, out_dir, 64*1024, 4*64*1024, 4096)

hunk(cstr in_file, cstr out_dir, int avg_hunk_size, int max_hunk_size, int sum_window_size)
	Mkdir_if(out_dir)
	cp_attrs(in_file, out_dir)
	FILE *in = Fopen(in_file, "r")

	new(b, buffer, avg_hunk_size*2)
	new(out_file, buffer, 256)
	int c
	int sum = 0
	int hunk_count = 0

	off_t offset = 0

	repeat
		Getc(c, in)
		if c != EOF
			buffer_cat_char(b, (char)c)
			sum += c
		if (int)buffer_get_size(b) >= sum_window_size || c == EOF
			if end_of_hunk() || (int)buffer_get_size(b) == max_hunk_size || c == EOF
				buffer_clear(out_file)
				Sprintf(out_file, "%016x", offset)
				# TODO store hunks in a shared directory, unique by sha1, and hard link to the file's own directory using offset file
				char *out_file_path = path_cat(out_dir, buffer_get_start(out_file))
				FILE *out = Fopen(out_file_path, "wb")
				Fwrite(buffer_get_start(b), 1, buffer_get_size(b), out)
				Fclose(out)
				Free(out_file_path)
				++hunk_count
				offset += buffer_get_size(b)
				if c == EOF
					break
				buffer_clear(b)
				sum = 0
			 else
				sum -= buffer_get_start(b)[buffer_get_size(b)-sum_window_size]

	Fclose(in)

def end_of_hunk() sum % avg_hunk_size == 0

export cstr
use io path
