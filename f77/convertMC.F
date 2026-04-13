      PROGRAM convertMC
      IMPLICIT NONE
C     Fortran77 program to read MC data from a text file and coverting to a
C     different format for further processing

C     FMT is a character function
      CHARACTER*26 FMT

      INTEGER UIN
      INTEGER UOUT
      INTEGER NEV
      CHARACTER*80 FINNAM
      CHARACTER*80 FOUTNAM
      CHARACTER*200 LINE

      INTEGER TMP1, TMP2
      INTEGER CURREV
      INTEGER IDX, PID, STATUS
      DOUBLE PRECISION PX, PY, PZ, ENE, MASS

C     Open input file
      UIN = 10
      FINNAM = 'data/dimuon_91.txt'
      OPEN(UIN, FILE = FINNAM, STATUS = 'OLD')

C     Open output file
      UOUT = 20
      FOUTNAM = 'data/dimuon_91_stable_task1.txt'
      OPEN(UOUT, FILE = FOUTNAM, STATUS = 'UNKNOWN')

C     Loop
      NEV = 0
      DO WHILE (.TRUE.)
         READ(UIN,'(A)',END=100) LINE
C        WRITE(*,*) LINE
C        Event line: keep event number
         IF (LINE(1:1).EQ.'E') THEN
            READ(LINE(3:),*) CURREV, TMP1, TMP2
            NEV = NEV + 1
            WRITE(UOUT,'(1X,A2,1X,I12)') 'E:', CURREV

C        Particle line: read kinematics and status
         ELSE IF (LINE(1:1).EQ.'P') THEN
            READ(LINE(3:),*) IDX, TMP1, PID, PX, PY, PZ,
     &                        ENE, MASS, STATUS

C         Keep only stable particles (STATUS = 1)
C         Set formatting from FMT function

            IF (STATUS.EQ.1) THEN
               WRITE(UOUT,'(1X,A2,1X,I12,I12,5A26,5X)') 'P:',
     &              IDX, PID,
     &              FMT(PX), FMT(PY), FMT(PZ), FMT(ENE), FMT(MASS)
            END IF
         END IF

      END DO

 100  WRITE(*,*) 'DONE! ', NEV

      END


      CHARACTER*26 FUNCTION FMT(VAL)
C     Match the reference file formatting based on value
      IMPLICIT NONE
      DOUBLE PRECISION VAL
      CHARACTER*26 TMP

      IF (VAL .EQ. 0.0D0) THEN
C        Zero: fixed-point with 16 decimal places
         WRITE(TMP, '(3X, F18.16, 5X)') VAL
         FMT = TMP
      ELSE IF (ABS(VAL) .LT. 0.1D0) THEN
C        Less than 0.1: scientific notation with 16 decimal places
         WRITE(TMP, '(2X, ES24.16E3)') VAL
         FMT = TMP
      ELSE IF (ABS(VAL) .LT. 1.0D0) THEN
C        Less than 1.0: fixed-point with 17 decimal places
         WRITE(TMP, '(F21.17, 5X)') VAL
         FMT = TMP
      ELSE IF (ABS(VAL) .LT. 10.0D0) THEN
C        Less than 10: fixed-point with 16 decimal places
         WRITE(TMP, '(2X, F19.16, 5X)') VAL
         FMT = TMP
      ELSE
C        Greater or eq to 10: fixed-point with 15 decimal places
         WRITE(TMP, '(2X, F19.15, 5X)') VAL
C        Remove trailing zero to match refrence file formatting
         IF (TMP(26:26) .EQ. '0') TMP(26:26) = ' '
         FMT = TMP
      END IF

      RETURN
      END