#!/lang/b
use openssl/sha.h
use openssl/md5.h
use b
#link ssl
#export LDFLAGS="-lssl"

def block_size 4096

def hash_dir "/hash"

Main()
	find_main(f, s)
		if S_ISREG(s->st_mode)
			uchar sha1sum[SHA_DIGEST_LENGTH]
#			char sha1sum_hex[SHA_DIGEST_LENGTH*2+1]
			uchar md5sum[MD5_DIGEST_LENGTH]
#			char md5sum_hex[MD5_DIGEST_LENGTH*2+1]
			char hash_file[SHA_DIGEST_LENGTH*2+1+MD5_DIGEST_LENGTH*2+1]

			size_t length = 0

			new(sha1, SHA_CTX)
			new(md5, MD5_CTX)
			fd = Open(f, O_RDONLY)
			each_block(b, fd)
				char *start = buffer_get_start(b)
				size_t size = buffer_get_size(b)
				SHA1_Update(sha1, start, size)
				MD5_Update(md5, start, size)
				length += size
			final(sha1, SHA_CTX, sha1sum)
			final(md5, MD5_CTX, md5sum)

			uchar *ch
			char *out = hash_file
			for ch=&sha1sum[0]; ch < sha1sum+SHA_DIGEST_LENGTH; ++ch, out+=2
				snprintf(out, 3, "%02x", *ch)
			*(out++) = '-';
			for ch=&md5sum[0]; ch < md5sum+MD5_DIGEST_LENGTH; ++ch, out+=2
				snprintf(out, 3, "%02x", *ch)
			*out = '\0';

			cstr hash_path = path_cat(hash_dir, hash_file)

			if exists(hash_path)
				# Link(hash_path, f)
				.
			 else
				Link(f, hash_path)

			Sayf("%s\t%s", hash_file, f)
			Close(fd)

def each_block(b, fd)
	new(b, buffer, block_size)
	repeat
		buffer_set_size(b, Read(fd, buffer_get_start(b), block_size))
		if buffer_get_size(b) == 0
			break
		.

def SHA_CTX_init(sha1)
	SHA1_Init(sha1)
def SHA_CTX_final(sha1, md)
	SHA1_Final(md, sha1)

def MD5_CTX_init(md5)
	MD5_Init(md5)
def MD5_CTX_final(md5, md)
	MD5_Final(md, md5)

def final(o, type)
	type^^_final(o)
def final(o, type, a0)
	type^^_final(o, a0)
def final(o, type, a0, a1)
	type^^_final(o, a0, a1)

