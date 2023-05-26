CREATE OR REPLACE PACKAGE TRA_CM.SPCMM_ORDINAL
AS
/******************************************************************************
   NAME:       getSeqNo
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2009-03-03             1. Created this package.
******************************************************************************/
    e_error       EXCEPTION;
    v_errorcode   VARCHAR2 (200);
    v_errortext   VARCHAR2 (200);

    FUNCTION make_ord_str (
        p_prefix    IN   CO_ORDINAL.prefix%TYPE,
        p_suffix   IN   VARCHAR2,
        p_seq_n     IN   NUMBER,
        p_length    IN   INTEGER
    )
        RETURN VARCHAR2;
        
    PROCEDURE get_seq (
      p_type      IN       CO_ORDINAL.ordinal_type%TYPE,
      p_prefix    IN       CO_ORDINAL.prefix%TYPE,
      p_length    IN       INTEGER,
      p_suffix   IN       VARCHAR2,
      o_seq       OUT      VARCHAR2
    );

END SPCMM_ORDINAL;
/