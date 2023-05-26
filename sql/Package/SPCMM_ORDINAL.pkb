CREATE OR REPLACE PACKAGE BODY TRA_CM.spcmm_ordinal
AS


   FUNCTION make_ord_str (
      p_prefix    IN   CO_ORDINAL.prefix%TYPE,
      p_suffix   IN   VARCHAR2,
      p_seq_n     IN   NUMBER,
      p_length    IN   INTEGER
   )
      RETURN VARCHAR2
   IS
      o_seq   VARCHAR2 (30);
   BEGIN
      o_seq := p_prefix || LPAD (p_seq_n, p_length, '0') || p_suffix;
      RETURN o_seq;
   END;
   

   PROCEDURE get_seq (
      p_type      IN       CO_ORDINAL.ordinal_type%TYPE,
      p_prefix    IN       CO_ORDINAL.prefix%TYPE,
      p_length    IN       INTEGER,
      p_suffix   IN       VARCHAR2,
      o_seq       OUT      VARCHAR2
   )
   IS
      o_seq_n   NUMBER (9);
   BEGIN
      SELECT        ordinal + 1
               INTO o_seq_n
               FROM CO_ORDINAL
              WHERE ordinal_type = p_type AND 
                    prefix = UPPER (p_prefix)
      FOR UPDATE OF ordinal;

      UPDATE CO_ORDINAL
         SET ordinal = o_seq_n,
             last_dt = SYSDATE
       WHERE ordinal_type = p_type AND 
             prefix = UPPER (p_prefix);

      o_seq := make_ord_str (p_prefix, p_suffix, o_seq_n, p_length);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO CO_ORDINAL
                     (ordinal_type, prefix, ordinal, last_dt )
              VALUES (p_type, UPPER (p_prefix), 1 , SYSDATE);

         o_seq := make_ord_str (p_prefix, p_suffix, 1, p_length);
      WHEN OTHERS
      THEN
         o_seq := '';
   END;

END spcmm_ordinal;
/