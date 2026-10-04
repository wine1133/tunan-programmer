<template>
	<view class="nav-container">
		<uni-nav-bar>
			<view class="input-view">
				<uni-icons type="search" size="22" color="#666"/>
				<input confirm-type="search" class="nav-bar-input" placeholder="19588节开发课程,任你搜">
			</view>
		</uni-nav-bar>
	</view>
</template>

<script>
</script>

<style>
	
	.input-view{
		display: flex;
		flex-direction: row;
		width: 650rpx;
		background-color: #f8f8f8;
		height: 30px;
		line-height: 30px;
		border-radius: 20px;
		padding: 0 10px;
		margin: 7px 0;
	}
	
	.nav-bar-input{
		height: 30px;
		line-height: 30px;
		padding: 0 5px;
	}
	
</style>
