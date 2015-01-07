<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- 
    Template for the page that controls the updating or rebuilding of the Search Index. 
-->

<section id="indexer" role="region">
    <#if status.statusType == "IDLE">
        <h3>The search indexer has been idle since ${status.since?datetime}</h3>

    <#elseif status.statusType = "PROCESSING_URIS">
        <h3>The search indexer has been processing URIs since ${status.since?datetime}</h3>
        <p><@showIndexerCounts "URI_COUNTS", status /></p>
        <p><@showElapsedTime status.elapsed /> Expected completion ${status.expectedCompletion?datetime}.</p>

    <#elseif status.statusType = "PROCESSING_STMTS">
        <h3>The search indexer has been processing changed statements since ${status.since?datetime}</h3>
        <p><@showIndexerCounts "STATEMENT_COUNTS", status /></p>
        <p><@showElapsedTime status.elapsed /> Expected completion ${status.expectedCompletion?datetime}.</p>

    <#elseif status.statusType = "PREPARING_REBUILD">
        <h3>The search indexer has been preparing to rebuild the index since ${status.since?datetime}</h3>

    <#else>
        <h3>The search indexer status is: ${status.statusType}
    </#if>
    
    
    <form action="${rebuildUrl}" method="POST">
        <p>
            <#if status.statusType == "IDLE">
                <input class="submit" type="submit" name="rebuild" value="${i18n().rebuild_button}" role="button" />
                ${i18n().reset_search_index}
            </#if>
        </p>
    </form>


    <h3>History</h3>
    <table class="history">
        <tr> <th>Event</th> <th>Status</th> <th>Since</th> <th>Counts</th> </tr>
        <#list history as ie>
           <@showIndexerEvent ie />
        </#list>
    </table>
</section>


<#macro showElapsedTime elapsed>
    Elapsed time ${elapsed[0]}:${elapsed[1]}:${elapsed[2]}.
</#macro>


<#macro showIndexerEvent event>
    <tr>
        <td>${event.event}</td>
        <td>${event.statusType}</td>
        <td>${event.since?datetime}</td>
        <td><@showIndexerCounts event.countsType, event /></td>
    </tr>
</#macro>


<#macro showIndexerCounts countsType, counts>
   <#if countsType == "URI_COUNTS">
       Updated: ${counts.updated}, deleted: ${counts.deleted}, remaining: ${counts.remaining}, total: ${counts.total}
   <#elseif countsType == "STATEMENT_COUNTS">
       Processed: ${counts.processed}, remaining: ${counts.remaining}, total: ${counts.total}
   <#elseif countsType == "REBUILD_COUNTS">
       Number of individuals before rebuild: ${counts.numberOfIndividuals}
   </#if>
</#macro>