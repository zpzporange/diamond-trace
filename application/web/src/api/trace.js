import request from '@/utils/request'

export function uplink(data) {
  return request({
    url: '/uplink',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  })
}

// getFruitInfo
export function getDiamondInfo(data) {
  return request({
    url: '/getDiamondInfo',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  })
}

// getFruitList
export function getDiamondList(data) {
  return request({
    url: '/getDiamondList',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  })
}

// getAllFruitInfo
export function getAllDiamondInfo(data) {
  return request({
    url: '/getAllDiamondInfo',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  })
}

// getFruitHistory
export function getDiamondHistory(data) {
  return request({
    url: '/getDiamondHistory',
    method: 'post',
    headers: {
      'Content-Type': 'multipart/form-data'
    },
    data
  })
}

