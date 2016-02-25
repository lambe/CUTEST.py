import os
import platform
import numpy as np
cimport numpy as np
from libcpp cimport bool

cdef extern from "/usr/local/include/cutest.h":
    ctypedef int      integer;
    ctypedef float    real;
    ctypedef double   doublereal;
    ctypedef bint     logical;


    ctypedef struct VarTypes:
        int nbnds, neq, nlin, nrange, nlower, nupper, nineq, nineq_lin, nineq_nlin, neq_lin, neq_nlin;

    void CUTEST_usetup  ( integer *status, const integer *funit,
                          const integer *iout, const integer *io_buffer,
                          integer *n, doublereal *x, doublereal *bl,
                          doublereal *bu );
    void CUTEST_csetup  ( integer *status, const integer *funit,
                          const integer *iout,
                          const integer *io_buffer, integer *n, integer *m,
                          doublereal *x, doublereal *bl, doublereal *bu,
                          doublereal *v, doublereal *cl, doublereal *cu,
                          logical *equatn, logical *linear, const integer *e_order,
                          const integer *l_order, const integer *v_order );

    void CUTEST_udimen  ( integer *status, const integer *funit, integer *n );
    void CUTEST_udimsh  ( integer *status, integer *nnzh );
    void CUTEST_udimse  ( integer *status, integer *ne, integer *nzh,
                          integer *nzirnh );
    void CUTEST_uvartype( integer *status, const integer *n, integer *ivarty );
    void CUTEST_unames  ( integer *status, const integer *n, char *pname,
                          char *vnames );
    void CUTEST_ureport ( integer *status, doublereal *calls, doublereal *time );


    void CUTEST_cdimen  ( integer *status, const integer *funit, integer *n,
                          integer *m );
    void CUTEST_cdimsj  ( integer *status, integer *nnzj );
    void CUTEST_cdimsh  ( integer *status, integer *nnzh );
    void CUTEST_cdimchp ( integer *status, integer *nnzchp );
    void CUTEST_cdimse  ( integer *status, integer *ne, integer *nzh,
                          integer *nzirnh );
    void CUTEST_cstats  ( integer *status, integer *nonlinear_variables_objective,
                          integer *nonlinear_variables_constraints,
                          integer *equality_constraints,
                          integer *linear_constraints );
    void CUTEST_cvartype( integer *status, const integer *n, integer *ivarty );
    void CUTEST_cnames  ( integer *status, const integer *n, const integer *m,
                          char *pname, char *vnames, char *gnames );
    void CUTEST_creport ( integer *status, doublereal *calls, doublereal *time );

    void CUTEST_connames( integer *status, const integer *m, char *gname );
    void CUTEST_pname   ( integer *status, const integer *funit, char *pname );
    void CUTEST_probname( integer *status, char *pname );
    void CUTEST_varnames( integer *status, const integer *n, char *vname );


    void CUTEST_ufn     ( integer *status, const integer *n, const doublereal *x,
                          doublereal *f );
    void CUTEST_ugr     ( integer *status, const integer *n, const doublereal *x,
                          doublereal *g );
    void CUTEST_uofg    ( integer *status, const integer *n, const doublereal *x,
                          doublereal *f, doublereal *g, const logical *grad );
    void CUTEST_udh     ( integer *status, const integer *n, const doublereal *x,
                          const integer *lh1, doublereal *h );
    void CUTEST_ushp    ( integer *status, const integer *n, integer *nnzh,
                          const integer *lh, integer *irnh, integer *icnh );
    void CUTEST_ush     ( integer *status, const integer *n, const doublereal *x,
                          integer *nnzh, const integer *lh, doublereal *h,
                          integer *irnh, integer *icnh );
    void CUTEST_ueh     ( integer *status, const integer *n, const doublereal *x,
                          integer *ne, const integer *le, integer *iprnhi,
                          integer *iprhi, const integer *lirnhi, integer *irnhi,
                          const integer *lhi, doublereal *hi, logical *byrows );
    void CUTEST_ugrdh   ( integer *status, const integer *n, const doublereal *x,
                          doublereal *g, const integer *lh1, doublereal *h);
    void CUTEST_ugrsh   ( integer *status, const integer *n, const doublereal *x,
                          doublereal *g, integer *nnzh, integer *lh, doublereal *h,
                          integer *irnh, integer *icnh );
    void CUTEST_ugreh   ( integer *status, const integer *n, const doublereal *x,
                          doublereal *g, integer *ne, const integer *le,
                          integer *iprnhi, integer *iprhi, const integer *lirnhi,
                          integer *irnhi, const integer *lhi, doublereal *hi,
                          const logical *byrows );
    void CUTEST_uhprod  ( integer *status, const integer *n, const logical *goth,
                          const doublereal *x, const doublereal *p, doublereal *r );
    void CUTEST_ushprod ( integer *status, const integer *n, const logical *goth,
                          const doublereal *x, const integer *nnzp,
                          const integer *indp, const doublereal *p,
                          integer *nnzr, integer *indr, doublereal *r );
    void CUTEST_ubandh  ( integer *status, const integer *n, const doublereal *x,
                          const integer *nsemib, doublereal *bandh,
                          const integer *lbandh, integer *maxsbw );


    void CUTEST_cfn     ( integer *status,  const integer *n, const integer *m,
                          const doublereal *x, doublereal *f, doublereal *c );
    void CUTEST_cofg    ( integer *status, const integer *n, const doublereal *x,
                          doublereal *f, doublereal *g, logical *grad );
    void CUTEST_cofsg   ( integer *status, const integer *n, const doublereal *x,
                          doublereal *f, integer *nnzg, const integer *lg,
                          doublereal *sg, integer *ivsg, logical *grad );
    void CUTEST_ccfg    ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, doublereal *c, const logical *jtrans,
                          const integer *lcjac1, const integer *lcjac2,
                      doublereal *cjac, logical *grad );
    void CUTEST_clfg    ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y, doublereal *f,
                          doublereal *g, logical *grad );
    void CUTEST_cgr     ( integer *status,  const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const logical *grlagf, doublereal *g,
                          const logical *jtrans, const integer *lcjac1,
                          const integer *lcjac2, doublereal *cjac );
    void CUTEST_csgr    ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const logical *grlagf, integer *nnzj,
                          const integer *lcjac, doublereal *cjac,
                          integer *indvar, integer *indfun );
    void CUTEST_ccfsg   ( integer *status,  const integer *n, const integer *m,
                          const doublereal *x, doublereal *c, integer *nnzj,
                          const integer *lcjac, doublereal *cjac, integer *indvar,
                          integer *indfun, const logical *grad );
    void CUTEST_ccifg   ( integer *status,  const integer *n, const integer *icon,
                          const doublereal *x, doublereal *ci, doublereal *gci,
                          const logical *grad );
    void CUTEST_ccifsg  ( integer *status, const integer *n, const integer *con,
                          const doublereal *x, doublereal *ci, integer *nnzsgc,
                          const integer *lsgci, doublereal *sgci, integer *ivsgci,
                          const logical *grad );
    void CUTEST_cgrdh   ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const logical *grlagf, doublereal *g,
                          const logical *jtrans, const integer *lcjac1,
                          const integer *lcjac2, doublereal *cjac,
                          const integer *lh1, doublereal *h );
    void CUTEST_cdh     ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const integer *lh1, doublereal *h );
    void CUTEST_cdhc    ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const integer *lh1, doublereal *h );
    void CUTEST_cshp    ( integer *status, const integer *n, integer *nnzh,
                          const integer *lh, integer *irnh, integer *icnh );
    void CUTEST_csh     ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y, integer *nnzh,
                          const integer *lh, doublereal *h, integer *irnh,
                          integer *icnh );
    void CUTEST_cshc    ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y, integer *nnzh,
                          const integer *lh, doublereal *h,
                          integer *irnh, integer *icnh );
    void CUTEST_ceh     ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          integer *ne, const integer *le, integer *iprnhi,
                          integer *iprhi, const integer *lirnhi, integer *irnhi,
                          const integer *lhi, doublereal *hi,
                          const logical *byrows );
    void CUTEST_cidh    ( integer *status, const integer *n, const doublereal *x,
                          const integer *iprob, const integer *lh1, doublereal *h );
    void CUTEST_cish    ( integer *status, const integer *n, const doublereal *x,
                          const integer *iprob, integer *nnzh, const integer *lh,
                          doublereal *h, integer *irnh, integer *icnh );
    void CUTEST_csgrsh  ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const logical *grlagf, integer *nnzj,
                          const integer *lcjac, doublereal *cjac, integer *indvar,
                          integer *indfun, integer *nnzh, const integer *lh,
                          doublereal *h, integer *irnh, integer *icnh );
    void CUTEST_csgreh  ( integer *status, const integer *n, const integer *m,
                          const doublereal *x, const doublereal *y,
                          const logical *grlagf, integer *nnzj,
                          const integer *lcjac, doublereal *cjac,
                          integer *indvar, integer *indfun,
                      integer *ne, const integer *le, integer *iprnhi,
                          integer *iprhi, const integer *lirnhi,
                          integer *irnhi, const integer *lhi, doublereal *hi,
                          const logical *byrows );
    void CUTEST_chprod  ( integer *status, const integer *n, const integer *m,
                          const logical *goth, const doublereal *x,
                          const doublereal *y, doublereal *p, doublereal *q );
    void CUTEST_cshprod ( integer *status, const integer *n, const integer *m,
                          const logical *goth, const doublereal *x,
                          const doublereal *y, const integer *nnzp,
                          const integer *indp, const doublereal *p,
                          integer *nnzr, integer *indr, doublereal *r );
    void CUTEST_chcprod( integer *status, const integer *n, const integer *m,
                         const logical *goth, const doublereal *x,
                         const doublereal *y, doublereal *p, doublereal *q );
    void CUTEST_cshcprod( integer *status, const integer *n, const integer *m,
                          const logical *goth, const doublereal *x,
                          const doublereal *y, integer *nnzp, integer *indp,
                          doublereal *p, integer *nnzr, integer *indr,
                          doublereal *r );
    void CUTEST_cjprod  ( integer *status, const integer *n, const integer *m,
                          const logical *gotj, const logical *jtrans,
                          const doublereal *x, const doublereal *p,
                          const integer *lp, doublereal *r, const integer *lr );
    void CUTEST_csjprod ( integer *status, const integer *n, const integer *m,
                          const logical *gotj, const logical *jtrans,
                          const doublereal *x, const integer *nnzp,
                          const integer *indp, const doublereal *p,
                          const integer *lp, integer *nnzr,
                          integer *indr, doublereal *r, const integer *lr );
    void CUTEST_cchprods( integer *status, const integer *n, const integer *m,
                          const logical *goth, const doublereal *x,
                          const doublereal *p, const integer *lchp,
                          doublereal *chpval, integer *chpind, integer *chpptr );


    void CUTEST_uterminate( integer *status );
    void CUTEST_cterminate( integer *status );


    void FORTRAN_open(  const integer *funit, const char *fname, integer *ierr );
    void FORTRAN_close( const integer *funit, integer *ierr );


    void *CUTEst_malloc( void *object, int length, size_t s );
    void *CUTEst_calloc( void *object, int length, size_t s );
    void *CUTEst_realloc( void *object, int length, size_t s );
    void  CUTEst_free( void **object );

#######Cython interface#########################

cdef char* CUTEstException(int info):
    """Analyse error return from C function """
    cdef char* msg
    if info == 1:
        msg = 'memory allocation error'
    elif info == 2:
        msg = 'array bound error'
    elif info == 3:
        msg = 'evaluation error'
    else:
        msg = 'unknow error'
    return msg        

cdef cutest_error(int info):
    if info > 0:
        CUTEstException(info)

cpdef loadCutestProb(char* name):
    cdef int funit=42 # FORTRAN unit number for OUTSDIF.d
    cdef char * fname="OUTSDIF.d"
    cdef int status  # Exit flag from OPEN and CLOSE
    cdef int iout=6
    cdef int io_buffer = 11
    cdef int nvar
    cdef int ncon

    FORTRAN_open(&funit, fname, &status)
    cutest_error(status)
    
    CUTEST_cdimen( &status, &funit, &nvar , &ncon )
    cutest_error(status)
    print nvar,ncon

    cdef np.ndarray[double, ndim=1, mode='c' ] x = np.empty((nvar,), dtype = np.double)
    cdef np.ndarray[double, ndim=1, mode='c'] bl = np.empty((nvar,), dtype = np.double)
    cdef np.ndarray[double, ndim=1, mode='c'] bu = np.empty((nvar,), dtype = np.double) 
    cdef np.ndarray[double, ndim=1, mode='c'] v = np.empty((ncon,), dtype = np.double) 
    cdef np.ndarray[double, ndim=1, mode='c'] cl = np.empty((ncon,), dtype = np.double)
    cdef np.ndarray[double, ndim=1, mode='c'] cu = np.empty((ncon,), dtype = np.double) 
    cdef np.ndarray[logical, cast=True] equatn = np.arange(ncon, dtype='>i1')
    cdef np.ndarray[logical, cast=True] linear = np.arange(ncon, dtype='>i1')

    cdef int const1=5
    cdef int const2=6
    cdef int const3=1


    if ncon > 0:
        CUTEST_csetup(&status, &funit, &const1, &const2, &nvar, &ncon, &x[0], &bl[0], &bu[0], &v[0], &cl[0], &cu[0], &equatn[0], &linear[0], &const3, &const3, &const3)
    else:
        CUTEST_usetup( &status, &funit, &const1, &const2, &nvar, &x[0], &bl[0], &bu[0])   
   
    cutest_error(status)
   
    print 'equatn'
    print equatn 

    print 'linear'
    print linear

    cdef np.ndarray[long, ndim=1] lin = np.where(linear==1)[0] 
    print 'variable lin:'
    print lin 
    cdef np.ndarray[long, ndim=1] nln = np.where(linear==0)[0]
    
    print 'var nln:'
    print nln

    cdef int nlin = np.sum(linear)
    print 'var. nlin'
    print nlin
    cdef int nnln = ncon - nlin
    print 'var. nnln'
    print nnln
    cdef int nnzh = 0
    cdef int nnzj = 0

    if ncon > 0:
        CUTEST_cdimsh(&status, &nnzh)
        CUTEST_cdimsj(&status, &nnzj)
        nnzj -= nvar
        print nnzj
        print nnzh
    else:
        CUTEST_udimsh(&status, &nnzh)
    cutest_error(status)

    FORTRAN_close(&funit, &status)
    cutest_error(status)

    ###### UTILISATION DE NLPy ########

