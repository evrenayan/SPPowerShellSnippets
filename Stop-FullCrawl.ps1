# Stop search full crawl for all content sources (Microsoft SharePoint on-premise farm)

Get-SPEnterpriseSearchCrawlContentSource -SearchApplication "Search Service Application" | ForEach-Object {  
    If($_.CrawlStatus -ne "Crawling Full") 
    {
        Write-Host "Stopping crawl on Content source $($_.Name)..." 
        $_.StopCrawl()  
        While ($_.CrawlStatus -ne "Idle")
        {
            Write-Host "Waiting to crawl to be stopped..." -f DarkYellow
            sleep 3
        }
        write-host "Crawl Stopped Successfully!" -f DarkGreen
    }
    else
    {
        write-host "Crawl Status of the Content source '$($_.Name)' is Idle!" -f DarkGreen
    }
}
