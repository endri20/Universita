#define _GNU_SOURCE
#define BUF_SIZE 256

#include <unistd.h>
#include <limits.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

int main() {
        int fd, count;
        char data[ BUF_SIZE ];

        /* crea un file in sola scrittura */
        fd = open( "data.txt", O_RDONLY);
        if( fd == - 1 ) {
                printf( "%s\n", strerror( errno ) );
                exit( -1 );
        }

        /* memorizza la stringa sul file */
        count = read( fd, data, BUF_SIZE );
        if( count == -1 ) {
                printf( "%s\n", strerror( errno ) );
                exit( -1 );
        }
	int i=0;
	int n=0;

	off_t offset=0;
	int whence=SEEK_SET;
	for(offset=0; offset<=strlen(data); offset=offset+5)
	{
		n=lseek(fd, offset, whence);
        	printf("%c",data[offset]);
        	printf("%c",data[offset+1]);
	}
	
	printf("\n");
        close( fd );

        exit( 0 );
}
