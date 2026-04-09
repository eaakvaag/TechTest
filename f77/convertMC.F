      PROGRAM convertMC
      IMPLICIT NONE
C     Fortran77 program to read MC data from a text file and coverting to a
C     different format for further processing
      INTEGER UIN
      INTEGER NEV
      CHARACTER*80 FINNAM
      CHARACTER*200 LINE

C     Open input file
      UIN = 10
      FINNAM = 'data/dimuon_91.txt'
      OPEN(UIN, FILE = FINNAM, STATUS = 'OLD')

C     Loop
      NEV = 0
      DO WHILE (.TRUE.)
         READ(UIN,'(A)',END=100) LINE
         IF (LINE(1:1).EQ.'E') NEV = NEV + 1
         WRITE(*,*) LINE
      END DO
      
 100  WRITE(*,*) 'DONE! ', NEV

      END
      
