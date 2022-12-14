create or replace PROCEDURE WEB_REGIMENFISCAL(
  OUT_RESULTSET OUT SYS_REFCURSOR
) IS

  tRET VENTAS.CT_REGIMENFISCAL := VENTAS.CT_REGIMENFISCAL();
  rRET VENTAS.CR_REGIMENFISCAL := VENTAS.CR_REGIMENFISCAL(NULL,NULL, 0, 0);

  CURSOR C_CONSULTA IS
    SELECT 
      VENTAS.INTEGRA_REGIMENES.CLAVE, 
      VENTAS.INTEGRA_REGIMENES.DESCRIPCION,
      VENTAS.INTEGRA_REGIMENES.FISICA,
      VENTAS.INTEGRA_REGIMENES.MORAL
    FROM VENTAS.INTEGRA_REGIMENES;
      
  R_CONSULTA C_CONSULTA%ROWTYPE;

BEGIN

  OPEN C_CONSULTA;
    
  LOOP
    FETCH C_CONSULTA INTO R_CONSULTA;
    EXIT WHEN C_CONSULTA%NOTFOUND;
        
    rRET.CLAVE := NULL;
    rRET.DESCRIPCION := NULL;
    rRET.FISICA := NULL;
    rRET.MORAL := NULL;
        
    rRET.CLAVE := R_CONSULTA.CLAVE;
    rRET.DESCRIPCION := R_CONSULTA.DESCRIPCION;
    rRET.FISICA := R_CONSULTA.FISICA;
    rRET.MORAL := R_CONSULTA.MORAL;
        
    tRET.EXTEND;
    tRET(tRET.LAST) := rRET;
  END LOOP;
    
  CLOSE C_CONSULTA;
    
  OPEN OUT_RESULTSET FOR
    SELECT 
      T.CLAVE as CLAVE,
      T.DESCRIPCION as DESCRIPCION,
      T.FISICA as FISICA,
      T.MORAL as MORAL
    FROM TABLE (CAST(TRET AS VENTAS.CT_REGIMENFISCAL)) T;
    
END;