/* global axios */
import ApiClient from '../ApiClient';

class CaptainDocument extends ApiClient {
  constructor() {
    super('captain/documents', { accountScoped: true });
  }

  get({ page = 1, searchKey, topicId } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        searchKey,
        topic_id: topicId,
      },
    });
  }
}

export default new CaptainDocument();
