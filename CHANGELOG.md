## Memo

* page title
  - extension
  - site tree
  - layout / partial / templates
* page date
  - archives
  - layout / partial / templates  
  
* top_page
  * helper
    * breadcrumbs
  * class
    * index_creator

## TODO

* やっぱり page.date, page.title つかうかな？
  * middleman-vcs-time を利用して mtime
  * それを to_date して 
* summary の作成
  * タイトルのみリストアップ型
  * 要約表示型
* 低優先度
  * pager, paginate
  * partial or helper for share_sns
  * tags

## master

### 0.0.4

* /index.html がない場合の対処を追加
  * top page かの判定を path 名でするように（index.htmlがない時のため）
  * index_creator: index.html がない時は index template に従って作る


### 0.0.3

* released 2015-4-8
* PageAttributes 廃止。Utils::page_title(page), page_date(page) へ。
* site_treeでの make_tree を manipulate_resource_list ではなく ready に


### 0.0.2

* released 2015-4-7
* resource に PageAttributes::InstanceMethodsToResource を extend させる方式
  * akg.pages がそうだと ensure できないので、廃止するかも
  
### 0.0.1

