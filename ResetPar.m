function  x = ResetPar(x, par);
    global iter
    on = true; off = false;
    load(par.fxhat,'x0')
    %
    fb = 2 ;  
    % gradually decrease the constrains    
    fb = fb * 1.25^iter ;
    fs = 1./fb         ;
    fprintf('current fb is %3.3e \n', fb)
    % parameter values
    pindx = par.pindx  ;
    
    if (par.opt_sigP == on)
        isigP = pindx.lsigP      ;
        xnew   = exp(x(isigP))    ;
        xold   = exp(x0(isigP))   ;
        if (xnew > 1-par.gamma )
            x(isigP) = log( exp(x0(isigP)) + 0.1*rand ) ;
        end
    end

    if (par.opt_Q10P == on & par.opt_kdP == off)
        iQ10P = pindx.lQ10P;
        Q10P1 = exp(x(iQ10P))  ;
        Q10P0 = exp(x0(iQ10P)) ;
        %
        kP1  = par.kdP * Q10P1.^((par.vT - 30)/10)  ;
        kP0  = par.kdP * Q10P0.^((par.vT - 30)/10)  ;
        mkP1 = mean(kP1)  ;
        mkP0 = mean(kP0)  ; 
        if mkP1 > fb*mkP0 | mkP1 < fs*mkP0
            x(iQ10P) = log( exp(x0(iQ10P)) * (0.1*rand + 0.95) ) ;
        end
    end

    if (par.opt_Q10P == on & par.opt_kdP == on)
        iQ10P = pindx.lQ10P     ;
        Q10P1 = exp(x(iQ10P))  ;
        Q10P0 = exp(x0(iQ10P)) ;
        %
        ikdP = pindx.lkdP    ;
        kdP1 = exp(x(ikdP))  ;
        kdP0 = exp(x0(ikdP)) ;
        %
        kP1  = kdP1 * Q10P1.^((par.vT-30)/10) ;
        kP0  = kdP0 * Q10P0.^((par.vT-30)/10) ;
        mkP1 = mean(kP1) ;
        mkP0 = mean(kP0) ; 
        if mkP1 > fb*mkP0 | mkP1 < fs*mkP0
            x(iQ10P) = log( exp(x0(iQ10P))*(0.1*rand + 0.95) );
            x(ikdP)  = log( exp(x0(ikdP))*(0.1*rand + 0.95) );
        end
    end
    
    if (par.opt_Q10P == off & par.opt_kdP == on)
        ikdP = pindx.lkdP     ;
        xnew = exp(x(ikdP))   ;
        xold = exp(x0(ikdP))  ;
        if (xnew > fb*xold | xnew < fs*xold);
            x(ikdP) = log( exp(x0(ikdP))*(0.1*rand + 0.95) );
        end
    end

    if (par.opt_bP_T == on & par.opt_bP == off)
            ibP_T = pindx.bP_T  ;
            bm1   = x(ibP_T)    ;
            bm0   = x0(ibP_T)   ;
            %
            bC   = bm1*par.aveT + par.bC ;
            if mean(bC(:)) < 0.3 | mean(bC(:)) > 3
                x(ibP_T) = x0(ibP_T) + (0.02*rand - 0.01);
            end
    end
    
    if (par.opt_bP_T == on  & par.opt_bP == on)
        ibP_T = pindx.bP_T  ;
        bm1   = x(ibP_T)    ;
        bm0   = x0(ibP_T)   ;
        %
        ibP  = pindx.lbP    ;
        bb1  = exp(x(ibP))  ;
        bb0  = exp(x0(ibP)) ;
        %
        bP   = bm1*par.aveT + bb1 ;
        if nanmean(bP(:)) < 0.3 | nanmean(bP(:)) > 3
            x(ibP_T) = x0(ibP_T)  + (0.02*rand - 0.01);
            x(ibP)   = log( exp(x0(ibP))*(0.1*rand + 0.95) );
        end
    end
    
    if (par.opt_bP_T == off & par.opt_bP == on)
        ibP  = pindx.lbP    ;
        xnew = exp(x(ibP))  ;
        xold = exp(x0(ibP)) ;
        if (xnew < 0.3 | xnew > 3) ;
            x(ibP) = log( exp(x0(ibP))*(0.1*rand + 0.95) );
        end
    end
        
    if (par.opt_alpha == on)
        ialpha = pindx.lalpha    ;
        xnew   = exp(x(ialpha))  ;
        xold   = exp(x0(ialpha)) ;
        if (xnew > fb*xold | xnew < fs*xold);
            x(ialpha) = log( exp(x0(ialpha))*(0.1*rand + 0.95) );
        end
    end

    if (par.opt_beta == on)
        ibeta = pindx.lbeta    ;
        xnew  = exp(x(ibeta))  ;
        xold  = exp(x0(ibeta)) ;
        if (xnew > fb*xold | xnew < fs*xold);
            x(ibeta) = log( exp(x0(ibeta))*(0.1*rand + 0.95) );
        end
    end

    if (par.Cmodel == on) 
        if (par.opt_sigC == on)
            isigC = pindx.lsigC      ;
            xnew   = exp(x(isigC))    ;
            xold   = exp(x0(isigC))   ;
            if (xnew > 1-par.gamma )
                x(isigC) = log( exp(x0(isigC)) + 0.1*rand ) ;
            end
        end

        if (par.opt_kru == on)
            ikru = pindx.lkru    ;
            xnew   = exp(x(ikru))  ;
            xold   = exp(x0(ikru)) ;
            if (xnew > fb*xold | xnew < fs*xold);
                x(ikru) = log( exp(x0(ikru))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_krd == on)
            ikrd = pindx.lkrd    ;
            xnew   = exp(x(ikrd))  ;
            xold   = exp(x0(ikrd)) ;
            if (xnew > fb*xold | xnew < fs*xold);
                x(ikrd) = log( exp(x0(ikrd))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_etau == on)
            ietau = pindx.letau    ;
            xnew   = exp(x(ietau))  ;
            xold   = exp(x0(ietau)) ;
            if (xnew > 1);
                x(ietau) = log( xold ) ;
            end
        end

        if (par.opt_etad == on)
            ietad = pindx.letad    ;
            xnew   = exp(x(ietad))  ;
            xold   = exp(x0(ietad)) ;
            if ( xnew > 1 )
                x(ietad) = log( xold ) ;
            end
        end

        if (par.opt_bC_T == on & par.opt_bC == off)
            ibC_T = pindx.bC_T  ;
            bm1   = x(ibC_T)    ;
            bm0   = x0(ibC_T)   ;
            %
            bC   = bm1*par.aveT + par.bC ;
            if min(bC(:)) < 0.3 | max(bC(:)) > 3
                x(ibC_T) = x0(ibC_T) + (0.02*rand - 0.01);
            end
        end

        if (par.opt_bC_T == on  & par.opt_bC == on)
            ibC_T = pindx.bC_T  ;
            bm1   = x(ibC_T)    ;
            bm0   = x0(ibC_T)   ;
            %
            ibC  = pindx.lbC    ;
            bb1  = exp(x(ibC))  ;
            bb0  = exp(x0(ibC)) ;
            %
            bC   = bm1*par.aveT + bb1 ;
            if min(bC(:)) < 0.3 | max(bC(:)) > 3
                x(ibC_T) = x0(ibC_T)  + (0.02*rand - 0.01);
                x(ibC)   = log( exp(x0(ibC))*(0.1*rand + 0.95) );
            end
        end
        
        if (par.opt_bC_T == off & par.opt_bC == on)
            ibC  = pindx.lbC    ;
            xnew = exp(x(ibC))  ;
            xold = exp(x0(ibC)) ;
            if (xnew < 0.3 | xnew > 3) ;
                x(ibC) = log( exp(x0(ibC))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_d == on)
            id   = pindx.ld    ;
            xnew = exp(x(id))  ;
            xold = exp(x0(id)) ;
            if (xnew > fb*xold | xnew < fs*xold) ;
                x(id) = log( exp(x0(id))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_Q10C == on & par.opt_kdC == off)
            iQ10C = pindx.lQ10C ;
            Q10C1 = exp(x(iQ10C))   ;
            Q10C0 = exp(x0(iQ10C))  ;
            %
            kC1 = par.kdC * Q10C1.^((par.vT - 30)/10)  ;
            kC0 = par.kdC * Q10C0.^((par.vT - 30)/10)  ;
            mkC1 = mean(kC1) ;
            mkC0 = mean(kC0) ; 
            if any(kC1 < 0) | mkC1 > fb*mkC0 | mkC1 < fs*mkC0
                x(iQ10C) = log( exp(x0(iQ10C))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_Q10C == on & par.opt_kdC == on)
            iQ10C = pindx.lQ10C ;
            Q10C1 = exp(x(iQ10C))  ;
            Q10C0 = exp(x0(iQ10C)) ;
            %
            ikdC  = pindx.lkdC    ;
            kdC1  = exp(x(ikdC))  ;
            kdC0  = exp(x0(ikdC)) ;
            %
            kC1 = par.kdC * Q10C1.^((par.vT - 30)/10)  ;
            kC0 = par.kdC * Q10C0.^((par.vT - 30)/10)  ;
            mkC1 = mean(kC1) ;
            mkC0 = mean(kC0) ; 
            if any(kC1 < 0) | mkC1 > fb*mkC0 | mkC1 < fs*mkC0
                x(iQ10C) = log( exp(x0(iQ10C))*(0.1*rand + 0.95) );
                x(ikdC)  = log( exp(x0(ikdC))*(0.1*rand + 0.95) );
            end
        end

        if (par.opt_Q10C == off & par.opt_kdC == on)
            ikdC = pindx.lkdC ;
            xnew = exp(x(ikdC))  ;
            xold = exp(x0(ikdC)) ;
            if (xnew > fb*xold | xnew < fs*xold) ;
                x(ikdC) = log( exp(x0(ikdC))*(0.1*rand + 0.95) );
            end
        end
        
        if (par.opt_R_Si == on & par.opt_rR == on)
            iR_Si = pindx.R_Si ;
            irR   = pindx.lrR   ;
            
            par.R_Si = x(iR_Si)      ;
            par.rR   = exp(x(irR))   ;
            vout  = mkPIC2P(par)     ;
            RR    = vout.RR          ;
            nRR   = mean(diag(RR))   ;

            par.R_Si = x0(iR_Si)     ;
            par.rR   = exp(x0(irR))  ;
            vout  = mkPIC2P(par)     ;
            RR    = vout.RR          ;
            oRR   = mean(diag(RR))   ;
            
            if (nRR > fb*oRR | nRR < fs*oRR);
                x(iR_Si) = x0(iR_Si)  + (0.02*rand - 0.01);
                x(irR)   = log( exp(x0(irR))*(0.1*rand + 0.95) );
            end
        end
        
        if (par.opt_R_Si == on & par.opt_rR == off)
            iR_Si = pindx.R_Si     ;
            
            par.R_Si = x(iR_Si)    ;
            vout  = mkPIC2P(par)   ;
            RR    = vout.RR        ;
            nRR   = mean(diag(RR)) ;

            par.R_Si = x0(iR_Si)   ;
            vout  = mkPIC2P(par)   ;
            RR    = vout.RR        ;
            oRR   = mean(diag(RR)) ;
            
            if (nRR > fb*oRR | nRR < fs*oRR);
                x(iR_Si) = x0(iR_Si) + (0.02*rand - 0.01);
            end
        end

        if (par.opt_rR == on & par.opt_R_Si == off)
            irR  = pindx.lrR    ;
            xnew = exp(x(irR))  ;
            xold = exp(x0(irR)) ;
            if (xnew > fb*xold  | xnew < fs*xold);
                x(irR) = log( exp(x0(irR))*(0.1*rand + 0.95) );
            end
        end
        
        if (par.opt_cc == on)
            icc  = pindx.lcc    ;
            xnew = exp(x(icc))  ;
            xold = exp(x0(icc)) ;
            if (xnew > fb*xold  | xnew < fs*xold);
                x(icc) = log( exp(x0(icc))*(0.1*rand + 0.95) );
            end
        end
        
        if (par.opt_dd == on)
            idd  = pindx.ldd    ;
            xnew = exp(x(idd))  ;
            xold = exp(x0(idd)) ;
            if (xnew > fb*xold  | xnew < fs*xold);
                x(idd) = log( exp(x0(idd)) * (0.1*rand + 0.95) );
            end
        end
    end 
    % ------------------------------------------------------------
    if (par.Omodel == on)
        if (par.opt_O2C_T == on & par.opt_rO2C == off)
            iO2C_T = pindx.O2C_T ;
            O2C_T1 = x(iO2C_T)   ;
            O2C_T0 = x0(iO2C_T)  ;
            %
            O2C = O2C_T1*par.Tz + par.rO2C1 ;
            if (min(O2C) < 0)    ;
                x(iO2C_T) = x0(iO2C_T) + (0.02*rand - 0.01);
            end
        end

        if (par.opt_O2C_T == on & par.opt_rO2C == on)
            iO2C_T = pindx.O2C_T  ;
            O2C_T1 = x(iO2C_T)    ;
            O2C_T0 = x0(iO2C_T)   ;
            %
            irO2C = pindx.lrO2C   ;
            rO2C1 = exp(x(irO2C)) ;
            rO2C0 = exp(x0(irO2C));
            %
            O2C1 = O2C_T1*par.Tz*1e8 + rO2C1 ;
            O2C0 = O2C_T0*par.Tz*1e8 + rO2C0 ;
            if (mean(O2C1) < fs*mean(O2C0) | mean(O2C1) > fb*mean(O2C0)) 
                x(irO2C)  = log( exp(x0(irO2C))*(0.1*rand + 0.95) );
                x(iO2C_T) = x0(iO2C_T) + (0.02*rand - 0.01);
            end
        end

        if (par.opt_O2C_T == off & par.opt_rO2C == on)
            irO2C = pindx.lrO2C    ;
            xnew  = exp(x(irO2C))  ;
            xold  = exp(x0(irO2C)) ;
            if (xnew > fb*xold | xnew < fs*xold);
                x(irO2C) = log( exp(x0(irO2C))*(0.1*rand + 0.95) );
            end
        end
    end
    % ------------------------------------------------------------
    % dsi
    if (par.Simodel==on)
        if (par.opt_dsi == on)
            idsi = pindx.ldsi    ;
            xnew = exp(x(idsi))  ;
            xold = exp(x0(idsi)) ;
            if (xnew > 5000 | xnew < 1000);
                x(idsi) = x0(idsi);
            end
        end
        % at
        if (par.opt_at == on)
            iat  = pindx.lat    ;
            xnew = exp(x(iat))  ;
            xold = exp(x0(iat)) ;
            if (xnew > fb*xold  | xnew < fs*xold);
                x(iat) = x0(iat);
            end
        end
        % bt
        if (par.opt_bt == on)
            ibt  = pindx.lbt     ;
            xnew = exp(x(ibt))   ;
            xold = exp(x0(ibt))  ;
            if (xnew > 15000     | xnew < 10000);
                x(ibt) = x0(ibt) ;
            end
        end
        % aa
        if (par.opt_aa == on)
            iaa  = pindx.aa   ;
            xnew = x(iaa)     ;
            xold = x0(iaa)    ;
            if (xnew > 50 | xnew < -50);
                x(iaa) = x0(iaa);
            end
        end
        % bb
        if (par.opt_bb == on)
            ibb  = pindx.lbb    ;
            xnew = exp(x(ibb))  ;
            xold = exp(x0(ibb)) ;
            if (xnew > fb*xold  | xnew < fs*xold);
                x(ibb) = x0(ibb);
            end
        end    
    end

end

