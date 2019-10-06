shinyServer(function(input, output) {
    gen_data <- reactive({
        n = input$n_samples
        p = input$n_variables
        k = 2
        rho = 0.5
        
        set.seed(1)
        
        rows = matrix(rep(c(1:p), p), nrow = p, byrow = F)
        cols = t(rows)
        sigma = rho^abs(rows - cols)
        
        x = mvtnorm::rmvnorm(
            n = n,
            mean = rep(0, p),
            sigma = sigma)
        
        colnames(x) = sprintf("X%02d", 1:p)
        
        
        beta = c(rep(1, k), rep(0, p-k))
        y = x %*% beta + rnorm(n, 0, 1)
        
        return(list(x = x, y = y))
    })
    
    
    output$ls_plot <- renderPlot({
        plot(lm.fit(x = cbind(Int = 1, gen_data()$x), y = gen_data()$y)$coef[-1])
    })
    
    output$lasso_plot <- renderPlot({
        lasso = glmnet::cv.glmnet(
            x = gen_data()$x,
            y = gen_data()$y, 
            lambda = 10^seq(1, -5, length = 100))
        
        lasso %>% 
            coef2Df %>% 
            ggplot(aes(x = log(lambda), 
                       y = coef,
                       colour = variables,
                       label = variables)) +
            geom_line() +
            scale_y_continuous(breaks = c(-0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)) +
            geom_vline(xintercept = log(lasso$lambda.min)) +
            geom_dl(method = "angled.boxes") +
            theme(legend.position = "none")
    })
    
    output$ridge_plot <- renderPlot({
        ridge = glmnet::cv.glmnet(
            x = gen_data()$x,
            y = gen_data()$y, 
            lambda = 10^seq(1, -5, length = 100),
            alpha = 0)
        
        ridge %>% 
            coef2Df %>% 
            ggplot(aes(x = log(lambda), 
                       y = coef,
                       colour = variables,
                       label = variables)) +
            geom_line() +
            scale_y_continuous(breaks = c(-0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)) +
            geom_vline(xintercept = log(ridge$lambda.min)) +
            geom_dl(method = "angled.boxes") +
            theme(legend.position = "none")
    })

}) ## End ShinyServer
