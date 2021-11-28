package com.example.spos_v2.discovery

import vn.teko.discovery.core.model.DiscoveryProduct

data class SearchDiscoveryProductRequest(val query: String)
data class SearchDiscoveryProductResponse(val result: SearchDiscoveryProductResult = SearchDiscoveryProductResult())
data class SearchDiscoveryProductResult(val products: List<DiscoveryProduct> = listOf())